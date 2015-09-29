//
//  Notes.swift
//  Rate Me
//
//  Created by Oliver Reznik on 7/3/15.
//  Copyright (c) 2015 Oliver Reznik. All rights reserved.
//

/*

Parse Request Rationing:
    Login: 1-2
        -Check if new user
            -If yes then save user
    Save Picture: 1
        -Save picture
    Profile: 1 / hour
        -Load data
    Rate: 2 / 100 ratings
        -Pull in data on users
        -Save data for users


options
    -Gender Preference
    -

Info
    -Privacy Policy
    -Facebook Page
    -Twitter Page
    -About





Data and Security
classes
    -Max Index
        -Publicly readable
        -writable only via cloud code
    -User
        -only user has access
        -new objects can only be created via cloud code
        -a user data object is created with the user as a pointer
    -User Data
        -points to a private user object
        -Publicly readable
        -publically writable only via cloud code
        -user has permissions to write to it
        -new objects can only be created via cloud code
        -created with user


Parse Operations
startup
    -get current user
    -queue users
        -score data class

signin/up
    -get max index
        - max index class
    -save/sign in user
        -user class
    -save score data
        -score data class
    -save max index
        -max index class

rate
    -save rated user
        -score data class
    -save rating user
        -user class

change picture
    -save user
        -score data class







Detailed Parse Operations

change picture
    Score data's referenced user is the only one with access to update score data object. Picture url can be changed from the device.

save score
    Send dictionary of ids and the score given. For each id update the object by adding the score and other info. Check to make sure the score is acceptable.

save score given
    Score data's referenced user is the only one with access to update score data object. can be changed from the device.

sign up new user
    Send array of data that is checked for authenticity. Then create the user on the cloud.

queue users
    Get a bunch of publicly readable score data objects

set current user
    query the current users information



CLASSES

_User
    -Username (Facebook ID)
    -Email
    -Name

Score_Data
    -Index
    -User
    -Total_Score
    -Votes
    -n1-n10
    -Total_Score_Given
    -Votes_Given
    -Total_Difference
    -Picture URL
    -Gender
    -Name


MaxIndex
    -i









Left to Do
Security
-Rank
    -implement some sort of request management
Logoff / Delete
-In-App Purchase
    -Test further
-Design
-Push Notification
-Error Responses
-Efficiency
Gender Pref Change Response
Queue settings
Notifications for Ratings/Sharing
-Picture Size
-Analytics
-Device Management







Object function (a,d){if(c.isString(a))return b.Object._create.apply(this,arguments);a=a||{},d&&d.parse&&(a=this.parse(a));var e=b._getValue(this,"defaults");if(e&&(a=c.extend({},e,a)),d&&d.collection&&(this.collection=d.collection),this._serverData={},this._opSetQueue=[{}],this.attributes={},this._hashedJSON={},this._escapedAttributes={},this.cid=c.uniqueId("c"),this.changed={},this._silent={},this._pending={},!this.set(a,{silent:!0}))throw new Error("Can't create an invalid Parse.Object");this.changed={},this._silent={},this._pending={},this._hasData=!0,this._previousAttributes=c.clone(this.attributes),this.initialize.apply(this,arguments)} has no method 'Extend' 



*/





/*func createabunchofscoredataobjects() {
    var i = 3000
    while i < 6000 {
        var user = PFObject(className: "Score_Data")
        if randRange(0, 1) == 0 {
            user["gender"] = "male"
        }
        else {
            user["gender"] = "female"
        }
        user["first_name"] = String(randRange(-100, 100))
        user["index"] = i
        user["picture_url"] = "http://lorempixel.com/600/700/"
        let score = Double(randRange(0, 100)) / 10
        let votes = Double(randRange(0, 100))
        user["score"] = score
        user["votes"] = votes
        user["total_score"] = votes * score
        user.saveInBackground()
        i += 1
    }
    pront("done")
}*/









func dummyUsers() {
    //female
    let urls = "https://farm8.staticflickr.com/7487/15779120701_fafeaffca3_b.jpg  https://farm8.staticflickr.com/7640/16940626321_2ee4075c77_o.jpg  https://farm3.staticflickr.com/2805/12690654794_0785b739b3_b.jpg  https://farm3.staticflickr.com/2888/10744806395_62a634ec58_c.jpg  https://farm8.staticflickr.com/7605/17057199596_5b84c5cf84_b.jpg  https://farm9.staticflickr.com/8091/8455868570_e71b5f2660_b.jpg  https://farm1.staticflickr.com/456/19058091465_f08020f6ed_b.jpg  https://farm6.staticflickr.com/5451/17032091238_58d510155c_b.jpg  https://farm9.staticflickr.com/8702/16754152300_ba5d46ffe5_o.jpg  https://farm9.staticflickr.com/8800/17747548626_8dc933b7a3_b.jpg  https://farm8.staticflickr.com/7682/17584972058_8b97ba8c08_b.jpg  https://farm1.staticflickr.com/267/19969051660_f16b23a425_b.jpg  https://farm1.staticflickr.com/409/19970175309_d1494358b1_b.jpg  https://farm1.staticflickr.com/431/20114095500_2b59ce7146_b.jpg  https://farm6.staticflickr.com/5220/5524169155_5ec77fb701_b.jpg  https://farm4.staticflickr.com/3705/19679419314_dcb967bc0b_c.jpg  https://farm4.staticflickr.com/3812/13708214024_6b13e64195_b.jpg  https://farm1.staticflickr.com/545/19630150045_9f5d717ba9_b.jpg  https://farm2.staticflickr.com/1280/4682388523_c7f8f26dd2_b.jpg  https://farm1.staticflickr.com/415/20114169298_503709060f_b.jpg  https://farm6.staticflickr.com/5693/20664294226_4c0434ba3f_b.jpg  https://farm1.staticflickr.com/529/18143446593_3c4d7ce521_b.jpg  https://farm9.staticflickr.com/8764/17269520242_145d7ed350_b.jpg  https://farm8.staticflickr.com/7720/17061950682_378f449380_b.jpg  https://farm4.staticflickr.com/3321/3546816829_e2a7c5f353_b.jpg  https://farm6.staticflickr.com/5718/20374347189_e3502f6f50_b.jpg  https://farm1.staticflickr.com/258/20154255500_1ac0abcf25_b.jpg  https://farm1.staticflickr.com/363/19711687734_c641229fbb_b.jpg  https://farm1.staticflickr.com/394/20146309028_363af0b8e7_b.jpg  https://farm1.staticflickr.com/386/20325835722_3fd4a1b100_b.jpg  https://farm1.staticflickr.com/335/19638225884_7515e8a7ae_b.jpg  https://farm1.staticflickr.com/452/19606442324_69c06b3ca3_b.jpg  https://farm1.staticflickr.com/424/19739789659_131232782c_b.jpg  https://farm1.staticflickr.com/390/19722259400_de608929cb_b.jpg  https://farm1.staticflickr.com/556/19010521433_67c1904631_b.jpg  https://farm6.staticflickr.com/5595/18851421965_ebbd888bcb_b.jpg  https://farm1.staticflickr.com/540/18378539511_bbf4aa2c10_o.jpg  https://farm1.staticflickr.com/335/17905627894_0583a3dc0c_b.jpg  https://farm8.staticflickr.com/7680/16871265620_422ff08d02_b.jpg  https://farm4.staticflickr.com/3315/3567533154_cf03469526_b.jpg  https://farm1.staticflickr.com/428/19429394522_ea573d9f9d_b.jpg  https://farm1.staticflickr.com/428/19429394522_ea573d9f9d_b.jpg  https://farm9.staticflickr.com/8768/17150586095_d520361922_b.jpg  https://farm7.staticflickr.com/6149/5918582129_ea1dd6202f_b.jpg  https://farm8.staticflickr.com/7571/15825811795_a658514512_b.jpg  https://farm1.staticflickr.com/336/18667535814_022419bee9_b.jpg  https://farm1.staticflickr.com/324/20148656022_35952affa4_b.jpg  https://farm4.staticflickr.com/3656/3537022162_3d746c0f02_b.jpg  https://farm4.staticflickr.com/3501/3868041098_c4f572d740_o.jpg"
    let urlList = urls.componentsSeparatedByString("  ")
    for var i = 0; i < urlList.count; i++ {
        let dummy = PFObject(className: "Score_Data")
        for var n = 0; n < 11; n++ {
            dummy["n\(n)"] = 0
        }
        let dummyACL = PFACL()
        dummyACL.setPublicReadAccess(true)
        dummyACL.setPublicWriteAccess(false)
        dummy.ACL = dummyACL
        dummy["first_name"] = "Brenda"
        dummy["gender"] = "female"
        dummy["index"] = i + 1
        dummy["picture_url"] = urlList[i]
        dummy["rank"] = 1
        dummy["score"] = 0
        dummy["score_difference"] = 0
        dummy["score_given"] = 0
        dummy["total_score"] = 0
        dummy["user"] = PFUser(withoutDataWithClassName: "_User", objectId: "QB9PY3SF9A")
        dummy["votes"] = 0
        dummy["votes_given"] = 0
        dummy.saveInBackground()
    }
    
}

func men() {
    let urls = "https://farm8.staticflickr.com/7332/11664746305_1e2d7de788_b.jpg*https://farm9.staticflickr.com/8753/16989843460_a770cb6a59_z.jpg*https://farm9.staticflickr.com/8761/17489202743_87cbf9d31a_b.jpg*https://farm4.staticflickr.com/3077/2742221547_488d0eb3e1_b.jpg*https://farm3.staticflickr.com/2093/5778827420_2372a2a854_b.jpg*https://farm8.staticflickr.com/7035/6678108171_66d6d16314_b.jpg*https://farm9.staticflickr.com/8074/8330343027_fd33e00b56_b.jpg*https://farm9.staticflickr.com/8846/17923060719_ab878e392e_b.jpg*https://farm4.staticflickr.com/3908/15160708065_445caff323_o.jpg*https://farm8.staticflickr.com/7740/17136071810_cf214d97ea_o.jpg*https://farm9.staticflickr.com/8153/7524238556_47a178dde2_b.jpg*https://farm1.staticflickr.com/389/20097497379_51f3f7d4f9_b.jpg*https://farm8.staticflickr.com/7296/15858508643_9e35e749ed_b.jpg*https://farm9.staticflickr.com/8757/16459725203_64b023c208_b.jpg*https://farm1.staticflickr.com/335/19534287094_07591ccbb1_b.jpg*https://farm9.staticflickr.com/8010/7506717684_b45aa70157_b.jpg*https://farm8.staticflickr.com/7103/7181628059_abfae04c9d_b.jpg*https://farm9.staticflickr.com/8149/7506607248_d1ca973a65_b.jpg*https://farm4.staticflickr.com/3696/19856096088_3ede012a0c_b.jpg*https://farm9.staticflickr.com/8397/8687701580_d74e9d21c6_b.jpg*https://farm4.staticflickr.com/3249/5857268807_a9f3135f63_b.jpg*https://farm6.staticflickr.com/5534/18707786149_be7928e237_b.jpg*https://farm1.staticflickr.com/775/20502457608_1b0cf8351d_b.jpg*https://farm3.staticflickr.com/2631/3886604490_f3ca7c3622_b.jpg*https://farm1.staticflickr.com/1/223735_ccbb3fee03_o.jpg*https://farm9.staticflickr.com/8776/17964579475_c50f9226bb_b.jpg*https://farm4.staticflickr.com/3914/14351445404_ed8f6aa605_b.jpg*https://farm9.staticflickr.com/8807/18110457201_0a5ec8b6e0_b.jpg*https://farm6.staticflickr.com/5348/17853813879_d84028ae35_b.jpg*https://farm3.staticflickr.com/2944/15421483132_89fd30cd3f_b.jpg*https://farm1.staticflickr.com/442/19406859302_94bb2ee747_b.jpg*https://farm6.staticflickr.com/5522/18841580855_1ed962a18b_b.jpg*https://farm9.staticflickr.com/8777/16875871870_5b055981e2_b.jpg*https://farm9.staticflickr.com/8685/16809293139_b8c1c4ed8b_b.jpg*https://farm4.staticflickr.com/3143/2808993295_9de26b3172_b.jpg*https://farm6.staticflickr.com/5794/20476824549_08d70cffeb_b.jpg*https://farm1.staticflickr.com/334/20230114616_7b7fb12d7a_b.jpg*https://farm1.staticflickr.com/472/20015539909_8951401eca_b.jpg*https://farm1.staticflickr.com/267/19303843624_842f6d5346_b.jpg*https://farm1.staticflickr.com/429/19677729488_5170837a17_b.jpg*https://farm1.staticflickr.com/364/19042712351_6812d831d6_b.jpg*https://farm9.staticflickr.com/8820/17807173588_4eeeabc422_b.jpg*https://farm9.staticflickr.com/8712/17083682189_b325131ca2_b.jpg*https://farm8.staticflickr.com/7617/17082346130_e2111a2e87_b.jpg*https://farm8.staticflickr.com/7624/17204017176_c2e463e781_b.jpg*https://farm4.staticflickr.com/3315/3567533154_cf03469526_b.jpg*https://farm4.staticflickr.com/3147/5816661914_3b06463bed_b.jpg*https://farm1.staticflickr.com/318/18667543514_d0f297ddca_b.jpg*https://farm8.staticflickr.com/7698/17245343782_7cbd28e311_b.jpg*https://farm3.staticflickr.com/2902/14059733947_3f2a9b34dd_b.jpg*"
    let urlList = urls.componentsSeparatedByString("*")
    for var i = 0; i < urlList.count; i++ {
        let dummy = PFObject(className: "Score_Data")
        for var n = 0; n < 11; n++ {
            dummy["n\(n)"] = 0
        }
        let dummyACL = PFACL()
        dummyACL.setPublicReadAccess(true)
        dummyACL.setPublicWriteAccess(false)
        dummy.ACL = dummyACL
        dummy["first_name"] = "Dummy"
        dummy["gender"] = "male"
        dummy["index"] = i + 51
        dummy["picture_url"] = urlList[i]
        dummy["rank"] = 1
        dummy["score"] = 0
        dummy["score_difference"] = 0
        dummy["score_given"] = 0
        dummy["total_score"] = 0
        dummy["user"] = PFUser(withoutDataWithClassName: "_User", objectId: "QB9PY3SF9A")
        dummy["votes"] = 0
        dummy["votes_given"] = 0
        dummy.saveInBackground()
    }
}


