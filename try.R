

a <- fread("data/rb_dominant_daily.csv", header = FALSE)
View(a); is.data.table(a)

b <- a[, .(date = V1, product = V2, code = V3, 
           open = V7, high = V8, low = V9, close = V10,
           volume = V11)]

write.csv()


dt <- bars[, .(date = trading_day,
               code = instrument_id[1],
               open = open[1],
               high = max(high),
               low = min(low),
               close = close[.N],
               volume = volume[.N]),
          by = trading_day]
dt[, trading_day := NULL]
save(dt, file = "data/rb_dominant_daily.rda")

# 
# ## 使用新浪财经API获取期货历史数据
# 
# > http://blog.sina.com.cn/s/blog_7ed3ed3d0101gphj.html
# 
# 新浪期货历史数据API:
#   ```
# http://stock2.finance.sina.com.cn/futures/api/json.php/IndexService.getInnerFuturesMiniKLine<频率>?symbol=<品种代码>
#   ```
# 其中，<频率>包括：5分钟`5m`, 15分钟`15m`, 30分钟`30m`, 60分钟`60m` 以及日线数据。
# 品种代码可以是单独的一个合约，例如`RB1701`，也可以是连续合约，例如`RB0`.
# 
# ```
# eg. 螺纹钢连续，5分钟bar数据
# http://stock2.finance.sina.com.cn/futures/api/json.php/IndexService.getInnerFuturesMiniKLine5m?symbol=RB0
# ```
# 
# 可以在浏览器里打开上面的网址，发现数据格式为json
# 
# 
# ```{r}
# g.code <- "RB0"  # 回测品种：螺纹钢连续，RB0
# g.freq <- "5m"   # 调仓频率：5分钟
# 
# 
# # 构造url
# url <- sprintf("http://stock2.finance.sina.com.cn/futures/api/json.php/IndexService.getInnerFuturesMiniKLine%s?symbol=%s", g.freq, g.code)
# 
# library(jsonlite)
# library(data.table)
# 
# data <- fromJSON(url) 
# dt <- as.data.table(data)  
# colnames(dt) <-  c("date_time", "open", "high", "low", "close", "volume")
# dt <- cbind(
#   dt[, .(date_time = as.POSIXct(date_time))],
#   dt[, sapply(.SD, as.numeric), .SDcols = c("open", "high", "low", "close", "volume")]
# )
# View(dt)
# ```
# 
