Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 871147F3F
	for <xfs@oss.sgi.com>; Tue,  9 Dec 2014 02:26:19 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 65DAF304053
	for <xfs@oss.sgi.com>; Tue,  9 Dec 2014 00:26:16 -0800 (PST)
Received: from Axlion.ocius.nl (Axlion.ocius.nl [178.18.143.21]) by
	cuda.sgi.com with ESMTP id kqnGt9R6N0pM9gCd (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 09 Dec 2014 00:26:14 -0800 (PST)
Received: from [94.103.146.186] (helo=MacBook-Pro-Retina-van-Stefan.local)
	by Axlion.ocius.nl with esmtpsa (TLSv1:DHE-RSA-AES128-SHA:128)
	(Exim 4.84) (envelope-from <stefan@sharper.nl>) id 1XyFuB-0007lj-Br
	for xfs@oss.sgi.com; Tue, 09 Dec 2014 09:12:23 +0100
Message-ID: <5486B222.4080404@sharper.nl>
Date: Tue, 09 Dec 2014 09:26:10 +0100
From: "Stefan Bottelier | Sharper.nl" <stefan@sharper.nl>
MIME-Version: 1.0
Subject: Slow dir / Performance.
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello,

We have 2 Equallogic Systems, And a Dell Servers.

We have every server give a block device home dir , so the user data are 
on the home dir this is working great its format on xfs filesystem, and 
running iscsiadm version 2.0-870 with linux kernel 3.10.62

But when we logging on the server, the first time we do a dir command on 
the home dir, its take a long time when we get feedback on the dir , the 
next time is fast when we do a dir.
Now we have users on this systems and this problem give not good 
performance on sql and websites an e-mail we are running on the server.

Are the some information how i can fix ore maybe get this problem better 
under control ?

I hope so that somebody can help me, i am searching for more than 3 
weeks now.

Thanks,
Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
