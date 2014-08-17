可能的回复状态：
	OK
	Error
	Expired
	CAPTCHA
	Not Logged In
	Permission Denied
	Inconsistent Argument

签到域：
	name
	nickname
	gender
	studentId
	city
	school
	department
	grade
	district
	major
	classId
	phoneNumbers
	emails


/api/session/create POST
	-session
	enable_appauth?

/api/session/clear POST

/api/session/captcha_image

	image/jpeg

/api/session/active_appauth

/api/session/verify
	captcha | appauth



/api/account/login POST
	login_name | phone_number | email
	password

/api/account/logout POST

/api/account/change_password POST
	password
	new_password

/api/account/update POST
	nickname 
	name
	loginName
	email
	phoneNumer
	gender

创建组织
/api/account/create_organization POST
	name 组织名

/api/account/receive_messages GET
skip   limit

	
/api/account/register POST
	phone_number | email
	password
	phone_number_verification_code?

/api/account/send_verification_request_to_phone_number
	phone_number

获取个人订阅的所有活动	
/api/account/list_events
	boards
	categories
	skip
	limit
 
订阅的活动版块
/api/account/list_subscriptions

	eventBoards[]
	
	
	
/api/user/{userid}/info GET
	fields
		userInfo.gender
		userInfo.nickname
		userInfo.name
		studentInfo.studentId
		studentInfo.city
		studentInfo.school
		studentInfo.department
		studentInfo.grade
		studentInfo.district
		studentInfo.major
		studentInfo.classId
		extendedUserInfo.dayOfBirth
		extendedUserInfo.hobby
		extendedUserInfo.hometown
		extendedUserInfo.instanceMessageAccounts
		extendedUserInfo.isInRelation
		extendedUserInfo.location
		extendedUserInfo.monthOfBirth
		extendedUserInfo.sexualOrientation
		extendedUserInfo.yearOfBirth
		dynamic.numberOfFriends
		dynamic.numberOfFollowers
		dynamic.numberOfExecutingEvents
		dynamic.isFriend
		<dynamic.isfriend
		dynamic.eventsSignedUpFor
		<dynamic.executingEvent
		dynamic.eventsSignedUpFor.numberOfPraisers	
		<dynamic.eventsSignedUpFor.countPraiser 	

	Homogeneous to argument

/api/user/{userid}/update POST
	data
		JSON
			userInfo.gender int?
			userInfo.nickname text?
			userInfo.name text?
			studentInfo.studentId text?
			studentInfo.city text?
			studentInfo.school text?
			studentInfo.department text?
			studentInfo.grade long?
			studentInfo.district text?
			studentInfo.major text?
			studentInfo.classId text?
			extendedUserInfo.dayOfBirth int?
			extendedUserInfo.hobby text?
			extendedUserInfo.hometown text?
			extendedUserInfo.instanceMessageAccounts text?
			extendedUserInfo.isInRelation boolean?
			extendedUserInfo.location text?
			extendedUserInfo.monthOfBirth int?
			extendedUserInfo.sexualOrientation text?
			extendedUserInfo.yearOfBirth int?
		
			


获取用户参加的社团
/api/user/{userid}/list_organizations

	organizations[]
		id
		name
		roleType: "member:admin", "member:member", "follower"

/api/user/{userId}/follow POST
/api/user/{userId}/unfollow POST
/api/user/{userId}/list_followed_users GET

/api/user/{userId}/followers GET
</api/user/{userId}/list_followers

/api/user/{userId}/is_friend GET
/api/user/{userId}/set_avatar POST
/api/user/{userId}/avatar GET


加入黑名单
/api/user/{userId}/blacklist/add   post

取消加入黑名单
/api/user/{userId}/blacklist/remove   post

黑名单列表

/api/user/{userId}/blacklist/list  GET

	users[]
		id
		name
		nickName
		gender

获取用户所参加报名的活动列表
/api/user/{userId}/list_events_signed_up_for  GET
	skip
	limit

	events[]
		static
		<executingEvent
			id
			name
			location
			category
			begin
			end
			description
			stage
		dynamic
			numberOfPraisers
			<...countPraiser

获取用户所关注的活动列表
/api/user/{userId}/list_followed_events   GET
	userId
	skip
	limit




用户退出组织
/api/org/{orgid}/quit POST

用户向组织发送加入申请
/api/org/{orgid}/jreq/send POST

用户撤销已经向组织发送的加入申请
/api/org/{orgid}/jreq/cancel POST

用户判断自己是否已经向该组织发送过加入申请
/api/org/{orgid}/membership_status GET

	membershipStatus: "joined", "request-sent", "request-not-sent"


组织管理员列出收到的所有加入申请
/api/org/{orgid}/jreq/list GET

	requests[]
		id
		org
		user
		time
		seen

组织管理员标记一条申请已读
/api/org/{orgid}/jreq/process/{joining_request_id}/read POST

组织管理员批准一条加入申请
/api/org/{orgid}/jreq/process/{joining_request_id}/accept POST

组织管理员拒绝一条加入申请
/api/org/{orgid}/jreq/process/{joining_request_id}/reject POST

组织管理员忽略一条加入申请
/api/org/{orgid}/jreq/process/{joining_request_id}/ignore POST

	
获取组织直接成员信息
/api/org/{orgid}/direct_members GET  
</api/org/{orgid}/list_direct_members GET  
	skip
	limit

	users[]
		userId
		name
		gender
		nickname

/api/org/{orgid}/remove_member POST
	userId

创建活动
/api/org/{orgid}/event/create POST

关注社团
/api/org/{orgId}/follow POST

取消社团关注 
/api/org/{orgId}/unfollow POST


/api/org/{orgId}/followers GET
</api/org/{orgId}/list_followers
	关注社团的人员
	skip   limit

	users[]
		userId
		name
		gender
		nickname

/api/org/{orgId}/info
	fields
		organizationInfo.id
		organizationInfo.name
		organizationInfo.parent
		organizationInfo.email
		organizationInfo.contact
		organizationInfo.description
		extendedOrganizationInfo.type
		extendedOrganizationInfo.credit
		dynamic.numberOfMembers
		dynamic.numberOfFollowers
		dynamic.numberOfExecutingEvents
		dynamic.roleType?: "member:admin", "member:member", "follower"

/api/org/{orgId}/update
	data
		organizationInfo
			id
			name
			parent
			email
			contact
			description
		extendedOrganizationInfo
			type

/api/org/{orgId}/list_owned_event_boards

	eventBoards[]

/api/org/{orgId}/list_owned_assodirs

	assodirs[]
		name
		parent
		basename?
		description
		owner
		secret

/api/org/{orgId}/list_events GET
	skip
	limit
	stage: "drafting" | "executing" | "archived"

	events[]
		id
		name
		location
		category
		begin
		end
		description

/api/org/{orgId}/logo GET

/api/org/{orgId}/set_logo POST
	file

/api/org/{orgId}/list_including_assodirs

/api/org/{orgId}/appform/list_boxes
/api/org/{orgId}/appform/create_box

申请报名表
/api/org/{orgId}/appform/create_form

/api/event/{eventId}/follow POST
/api/event/{eventId}/unfollow POST

/api/event/{eventId}/followers GET
</api/event/{eventId}/list_followers

/api/event/{eventId}/praise POST
/api/event/{eventId}/unpraise POST
/api/event/{eventId}/number_of_praisers POST
/api/event/{eventId}/load GET
	fields
		name
		stage
		location
		category
		description
		begin
		end
		numberOfPeople
		numberOfPreservedSeats
		organizationName
		organizationId
		signingUpFields
		poster
		images
		attachments
		targets
		budgets[]
			amount
			number
			usage
	dynamic_data boolean?

	static
		Homogeneous to argument
	dynamic?
		numberOfPraiser
		hasPraised
		isFollowing
		hasSignedUp
		numberOfReplies

/api/event/{eventId}/update POST
	data
		JSON
			name
			location
			category
			description
			begin
			end
			numberOfPeople
			numberOfPreservedSeats
			budgets[]
				amount
				number
				usage
			signingUpFields
			<signUpFields
			saved
						
/api/event/{eventId}/publish POST
/api/event/{eventId}/archive POST
/api/event/{eventId}/target/add POST
	board_name

/api/event/{eventId}/target/drop POST
	board_name

/api/event/{eventId}/image/add POST
	file


/api/event/{eventId}/image/drop/{fileId} POST
/api/event/{eventId}/image/load/{fileId} GET
/api/event/{eventId}/attachment/add POST
	file

/api/event/{eventId}/attachment/drop/{fileId} POST
/api/event/{eventId}/attachment/load/{fileId} GET
/api/event/{eventId}/poster/set POST
	file

/api/event/{eventId}/poster/load GET
/api/event/{eventId}/poster/unset POST
/api/event/{eventId}/poster/is_existing GET

	isExisting

/api/event/{eventId}/comment/add_comment
	in_replying?
	content

/api/event/{eventId}/comment/list_comments
	in_replying_of?

	comments[]
		id
		content
		timeOfCommenting
		user
		inReplyingOf?
		totalRows
		countComment 
		countInReplying
		

/api/event/{eventId}/users_sign_up	GET

报名
/api/event/{eventId}/sign_up	POST
</api/event/{eventId}/signup
</api/event/{eventId}/signingup

取消报名
/api/event/{eventId}/cancel_signing_up POST
</api/event/{eventId}/cancel_signingup POST

/api/event_board/{eventBoardName}/list_published_events  GET
	categories

	events[]
		boradname
		eventId
		numberOfPraiser
		begin
		end
		category
		isPraised

/api/event_board/{eventBoardName}/accept		POST
	eventId

/api/event_board/{eventBoardName}/reject		POST
	eventId
	message

/api/event_board/{eventBoardName}/list_waiting_events  GET
	skip
	limit




模糊查询目录信息
/api/assodir/search	GET
	name 目录名

	assodirs[]

申请加入目录
/api/assodir/{assodirName}/apply	POST
	assodirName  orgId  

通过邀请码直接进入组织
/api/assodir/{assodirName}/enter	POST	
	assodirName  orgId  secret

获取某个目录中所有的社团
/api/assodir/{assodirName}/list_organizations	GET
	types?

	orgId

目录管理者允许加入
/api/assodir/{assodirName}/accept	POST
	orgId  


目录管理者拒绝加入
/api/assodir/{assodirName}/reject	POST
	orgId  

获取所有的请求加入信息
/api/assodir/{assodirName}/list_request_join  GET



申请表
/api/org/{orgId}/appform/{afId}/load  GET 
	fields {}
	stage
	box
	title
	text
	reply
	attachments
	associatedEvents
	associatedSponsorTransactions
	timeOfSubmission
	timeOfReplying
	approved



/api/org/{orgId}/appform/{afId}/update  POST

	fields {}
	stage
	box
	title
	text
	reply
	attachments
	associatedEvents
	associatedSponsorTransactions
	timeOfSubmission
	timeOfReplying
	approved



/api/org/{orgId}/appform/list_boxes   get 
	orgId
	Boolean archived


/api/org/{orgId}/appform/list_appforms  GET
	orgId
	stage



/api/org/{orgId}/appform_box/{afbId}/load   GET

	fields

/api/org/{orgId}/appform/{afId}/reply   POST
	approved
	reason   可以为空

/api/org/{orgId}/appform/{afId}/attachment/add		POST
	file

/api/org/{orgId}/appform/{afId}/attachment/drop{fileId}  POST 


/api/org/{orgId}/appform/{afId}/attachment/load 	 GET 

/api/org/{orgId}/appform/{afId}/event/add    POST 

/api/org/{orgId}/appform/{afId}/event/drop{fileId}  POST 

/api/org/{orgId}/appform_box/{afbId}/list_approved_appforms  GET
	
发布
/api/aboard/{aboardId}/announce    POST  
	name
	title
	title

回复
/api/aboard/{aboardId}/reply   POST
	messageId
	message	

获取所有的回复列表
/api/aboard/{aboardId}/replies  GET

发布的公告列表
/api/aboard/{aboardId}/announcements  GET  


/api/aboard/{aboardId}/load_announcement  GET  
	announcementId

	announcement
		id
		boardName
		title
		content
		recipient
		timeOfSending
		replys
		recipientsNotReplied


** 签到 **

新建签到表
/api/account/ossu/create
</api/account/ossu/create_signingup
	owner
	name
	fields

加载具体的签到信息
/api/ossu/{nlId}/load


获取所有签到的人员信息
/api/ossu/{nlId}/list


设置签到 绑定一个活动
/api/ossu/{nlId}/setup
	nlId
	eventId





用户自己可以管理的社团

/api/account/list_administrated_organizations GET  


赞助申请


创建赞助申请
/api/org/{orgId}/sponsor/create
	demanding	赞助要求
	title		主题
	publicity   是否公开
	providing   是否公开


加载组织发布的赞助申请
/api/org/{orgId}/sponsor/list
	skip
	limit

加载赞助 申请
/api/sponsor/{sponsorId}/load    GET


修改赞助申请
/api/sponsor/{sponsorId}/update 	POST

	data[]
		demanding
		title
		providing
		publicity
	

关联活动	
/api/sponsor/{sponsorId}/relation_event
	eventId

/api/sponsor/{sponsorId}/cancle_relation_event
	eventId	


申请认证
/api/sponsor/{sponsorId}/apply_certification
orgId


/api/sponsor/{sponsorId}/cancle_apply_certification
orgId

	
/api/sponsor/{sponsorId}/poster/set  POST
	file

/api/sponsor/{sponsorId}/poster/get  GET 

/api/message/message_types	POST

/api/message/load	GET
	messageIds

	messages

/api/message/archive	POST
	messageIds

/api/info/load_student_residence_info_directory
	id?

/api/info/generate_student_autoconfig
	data
		JSON
			city
			school
			district
			department
			major	
