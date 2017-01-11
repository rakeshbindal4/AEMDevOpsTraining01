package selenium.automation.test;

import java.util.concurrent.TimeUnit;
import org.junit.*;
import static org.junit.Assert.*;
import org.openqa.selenium.*;
import org.openqa.selenium.chrome.ChromeDriver;

import java.util.List;
import junit.framework.Assert;
import org.junit.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.Dimension;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.phantomjs.PhantomJSDriver;
import org.openqa.selenium.remote.DesiredCapabilities;

public class TestAEMDemoPage {
  private PhantomJSDriver driver;
  private String baseUrl;
  //private boolean acceptNextAlert = true;
  private StringBuffer verificationErrors = new StringBuffer();

  @Before
  public void setUp() throws Exception {
	DesiredCapabilities capabilities = DesiredCapabilities.phantomjs();
    driver = new PhantomJSDriver(capabilities);
    baseUrl = "http://localhost:4502";
    driver.manage().timeouts().implicitlyWait(30, TimeUnit.SECONDS);
  }

  @Test
  public void validateHomePage() throws Exception {
    driver.manage().window().setSize( new Dimension( 1124, 850 ) );
    driver.get(baseUrl + "/libs/granite/core/content/login.html?resource=%2Fcontent%2Faemdemo%2Fen.html&$$login$$=%24%24login%24%24");
    driver.findElement(By.id("username")).clear();
    driver.findElement(By.id("username")).sendKeys("admin");
    driver.findElement(By.id("password")).clear();
    driver.findElement(By.id("password")).sendKeys("admin");
    driver.findElement(By.cssSelector("button.coral-Button.coral-Button--primary")).click();
    driver.findElement(By.linkText("Français")).click();
    driver.findElement(By.linkText("English")).click();
  }

  @After
  public void tearDown() throws Exception {
    driver.quit();
    String verificationErrorString = verificationErrors.toString();
    if (!"".equals(verificationErrorString)) {
      fail(verificationErrorString);
    }
  }
}
