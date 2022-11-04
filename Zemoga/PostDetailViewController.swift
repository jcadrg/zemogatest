//
//  PostDetailViewController.swift
//  Zemoga
//
//  Created by Juanca on 2022-11-04.
//

import UIKit

struct Comments: Equatable, Codable {
    let id: Int
    let postId: Int
    let name: String
    let email: String
    var body: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case postId
        case name
        case email
        case body
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        postId = try container.decode(Int.self, forKey: .postId)
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
        body = try container.decode(String.self, forKey: .body)
    }
}

class PostDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    var post: Posts? = nil
//    var postID: Int = 0
    private var commentsArray = [Comments]()
    private var loading = true

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.postID = post!.id
        getComments(postid: post!.id)
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Networking
    
    private func getComments(postid: Int) {
        guard let  url = URL(string: "https://jsonplaceholder.typicode.com/comments?postId=\(postid)") else {
            fatalError("URL guard statement failed")
        }
        URLSession.shared.dataTask(with: url) { (data,response,error) in
            //Handling decoding
            if let data = data {
                guard let comment = try? JSONDecoder().decode([Comments].self, from:data) else {
                    fatalError("Error decoding data \(String(describing: error))")
                }
                self.commentsArray = comment
            }
            self.loading = false
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
        }.resume()
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! MainTableViewCell
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
