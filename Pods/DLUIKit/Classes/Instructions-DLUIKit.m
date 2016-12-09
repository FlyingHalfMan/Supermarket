/*
 
 
 
 
 
 
 版本：2.1.3
 时间：2016.9.7
 --
 1.autoTable读取图片bug修改，doneLoadingTableViewData方法优化
 
 
 
 版本：2.1.2
 时间：2016.9.2
 --
 1.AutoTable执行doneLoadingTableViewData方法，reloadData方法在最前面，以免变化数据源之后调用egoRefreshScrollViewDataSourceDidFinishedLoading方法，位移变化之后可能会执行显示cell的代理，数据有问题就会导致bug
 

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 */
