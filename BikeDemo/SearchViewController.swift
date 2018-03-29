//
//  SearchViewController.swift
//  BikeDemo
//
//  Created by 杨键 on 2018/3/28.
//  Copyright © 2018年 mclarenYang. All rights reserved.
//

import UIKit

protocol SearchVCDelegate {
    func didSelectLocationTipInTableView(selectedTip: AMapTip)
}

class SearchViewController: UIViewController {
    
    var delegate:SearchVCDelegate?
    
    let search = AMapSearchAPI()
    let request = AMapInputTipsSearchRequest()
    var resultArray:[AMapTip] = [AMapTip]() {
        didSet {ResultTableView.reloadData()}
    }
    
    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var ResultTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        search?.delegate = self
        request.cityLimit = true
        SearchBar.placeholder = "请输入关键字"
        SearchBar.delegate = self
        ResultTableView.delegate = self
        ResultTableView.dataSource = self
        
        SearchBar.becomeFirstResponder()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchViewController: AMapSearchDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath)
        
        cell.textLabel?.text = resultArray[indexPath.row].name
        cell.detailTextLabel?.text = resultArray[indexPath.row].district
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        SearchBar.resignFirstResponder()
        
        if self.delegate != nil {
            //传值
            self.delegate?.didSelectLocationTipInTableView(selectedTip: resultArray[indexPath.row])
        }
        hero.dismissViewController()
    }
    
    //查询
    func onInputTipsSearchDone(_ request: AMapInputTipsSearchRequest!, response: AMapInputTipsSearchResponse!) {
        NSLog("查询成功")
        for index in response.tips {
            resultArray.append(index)
        }
    }
    
    //查询出错
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        print("查询失败->Error:\(error)")
    }
    
    //改变字符的回调
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSLog("searchBar回调成功")
        //清空数组
        resultArray.removeAll()
        request.keywords = searchBar.text
        search?.aMapInputTipsSearch(request)
    }
    
    //点击搜索按钮关闭键盘
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
