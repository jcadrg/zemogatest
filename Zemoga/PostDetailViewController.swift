//
//  PostDetailViewController.swift
//  Zemoga
//
//  Created by Juanca on 2022-11-04.
//

import UIKit

//struct Comments: Equatable, Codable {
//    let id: Int
//    let postId: Int
//    let name: String
//    let email: String
//    let body: String
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case postId
//        case name
//        case email
//        case body
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decode(Int.self, forKey: .id)
//        postId = try container.decode(Int.self, forKey: .postId)
//        name = try container.decode(String.self, forKey: .name)
//        email = try container.decode(String.self, forKey: .email)
//        body = try container.decode(String.self, forKey: .body)
//    }
//}

//struct Author: Codable {
//    let id: Int
//    let name: String
//    let username: String
//    let email: String
//    let address: Address
//    let phone: String
//    let website: String
//    let company : Company
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case name
//        case username
//        case email
//        case address = "address"
//        case phone
//        case website
//        case company = "company"
//    }
//}
//
//struct Address : Codable {
//    let street: String
//    let suite: String
//    let city: String
//    let zipcode: String
//    let geo: Geo
//
//    enum CodingKeys: String, CodingKey {
//        case street
//        case suite
//        case city
//        case zipcode
//        case geo  = "geo"
//    }
//}
//
//struct Geo: Codable {
//    let lat: String
//    let lng: String
//
//    enum CodingKeys: String, CodingKey {
//        case lat
//        case lng
//    }
//}
//
//struct Company : Codable {
//    let name: String
//    let catchPhrase: String
//    let bs: String
//
//    enum CodingKeys: String, CodingKey {
//        case name
//        case catchPhrase
//        case bs
//    }
//}

class PostDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    var post: Posts? = nil
//    var postID: Int = 0
    private var commentsArray = [Comments]()
    private var authorsArray = [Author]()
    
    private var loading = true

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postDescription: UILabel!
    
    @IBOutlet weak var userRealName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userNumber: UILabel!
    @IBOutlet weak var userWebsite: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getComments(postid: post!.id)
        getAuthor(userid: post!.userId)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        postTitle.text = post?.title
        postDescription.text = post?.body
        
        
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
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }.resume()
    }
    
    private func getAuthor(userid: Int) {
        guard let  url = URL(string: "https://jsonplaceholder.typicode.com/users?id=\(userid)") else {
            fatalError("URL guard statement failed")
        }
        URLSession.shared.dataTask(with: url) { (data,response,error) in
            //Handling decoding
            if let data = data {
                print(userid)
                guard let author = try? JSONDecoder().decode([Author].self, from: data) else {
                    fatalError("Error decoding data \(String(describing: error))")
                }
                self.authorsArray = author
            }
            self.loading = false
            

            DispatchQueue.main.async {
                self.userRealName.text = self.authorsArray.first?.name
                self.userEmail.text = self.authorsArray.first?.email
                self.userNumber.text = self.authorsArray.first?.phone
                self.userWebsite.text = self.authorsArray.first?.website
            }
        }.resume()
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell
        let comment = commentsArray[indexPath.row]
        cell.titleLabel.text = comment.name
        cell.descriptionLabel.text = comment.body
        return cell
    }


    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Comments"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return commentsArray.count
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
