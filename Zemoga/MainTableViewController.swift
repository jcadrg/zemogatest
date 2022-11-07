//
//  MainTableViewController.swift
//  Zemoga
//
//  Created by Juanca on 2022-11-01.
//

import UIKit


class MainTableViewController: UITableViewController {
    
    private var postsArray = [Posts]()
    private var loading = true


    
    override func viewDidLoad() {
        


        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 30
        tableView.rowHeight = UITableView.automaticDimension
        self.refreshControl = UIRefreshControl()
        
        getPosts()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete non fav", style: .plain, target: self, action: #selector(deleteNonFavAction))
        refreshControl!.attributedTitle = NSAttributedString(string: "Getting all posts")
        refreshControl!.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if loading {
            return 1
        } else {
            return postsArray.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! MainTableViewCell
        
        if loading {
            cell.titleLabel?.text = "Loading ..."
        } else {
            let post = postsArray[indexPath.row]
            cell.titleLabel?.text = post.title
            
            if post.isFavorite {
                cell.isFavorite?.isHidden = false
            } else {
                cell.isFavorite?.isHidden = true
            }
        }
        


        return cell
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: { _, indexPath in
            self.postsArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
        })
        
        let post = postsArray[indexPath.row]
        let favoriteActionTitle = post.isFavorite ? "Unfavorite" : "Favorite"
        
        let favoriteAction = UITableViewRowAction(style: .normal, title: favoriteActionTitle, handler: { _, indexPath in
            self.postsArray[indexPath.row].isFavorite.toggle()
            self.sortedPostsArray()
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            
        })
        
        favoriteAction.backgroundColor = .systemYellow
        
                
        return [deleteAction, favoriteAction]
    }
    
    // MARK: Delete all rows except marked as fav
    
    @objc func deleteNonFavAction() {

        for post in self.postsArray {
            if !post.isFavorite {
                if let index = self.postsArray.firstIndex(of: post) {
                    self.postsArray.remove(at: index)
                }
            }
        }

        self.tableView.reloadData()
        
    }
    
    // MARK: Sorting array by marked as fav
    
    func sortedPostsArray() {
        
        postsArray = postsArray.sorted { $0.isFavorite && !$1.isFavorite }
        self.tableView.reloadData()
        
    }
    
    // MARK: Pull to refresh
    
    @objc func refresh(_ sender: AnyObject) {
        getPosts()
        refreshControl!.endRefreshing()
        self.tableView.reloadData()
    }
    
    // MARK: Networking
    
    private func getPosts() {
        guard let  url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            fatalError("URL guard statement failed")
        }
        URLSession.shared.dataTask(with: url) { (data,response,error) in
            //Handling decoding
            if let data = data {
                guard let post = try? JSONDecoder().decode([Posts].self, from:data) else {
                    fatalError("Error decoding data \(String(describing: error))")
                }
                self.postsArray = post
            }
            self.loading = false
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }.resume()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Place code you want to be performed when a cell is tapped inside of here, for example:
        let post = postsArray[indexPath.row]
        performSegue(withIdentifier: "postDetailSegue", sender: post) // Make sure your identifier makes sense and is preferably something memorable and easily recognisable.
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let vc = segue.destination as? PostDetailViewController {
            vc.post = sender as? Posts
        }
    }


}
