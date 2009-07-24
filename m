Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6ODpNOC131162 for <xfs@oss.sgi.com>; Fri, 24 Jul 2009 08:51:24 -0500
Received: from wf-out-1314.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BB0CF10BA026
	for <xfs@oss.sgi.com>; Fri, 24 Jul 2009 07:00:31 -0700 (PDT)
Received: from wf-out-1314.google.com (wf-out-1314.google.com
	[209.85.200.169]) by cuda.sgi.com with ESMTP id
	TAm6JLWJPQmiKJFa for <xfs@oss.sgi.com>;
	Fri, 24 Jul 2009 07:00:31 -0700 (PDT)
Received: by wf-out-1314.google.com with SMTP id 29so518392wff.32
	for <xfs@oss.sgi.com>; Fri, 24 Jul 2009 06:52:07 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 24 Jul 2009 21:52:06 +0800
Message-ID: <3ec42bdd0907240652q1bfb6784n9ba1c9e931b58900@mail.gmail.com>
Subject: A question about installing XFS filesystem support on Debian Lenny
From: feiji1983@gmail.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

i recenttly got a NAS hard disk box which run Debian Lenny ,the linux
kernel is 2.6.29. I can install xfsprogs with apt-get , after
formatting  a partition using mkfs.xfs,  i can't mount it with command
"mount -t xfs XXX XXX" , it says "xfs" is not supported. i think i
have to install a path,but can't find one using apt-get,can any body
tell me how can i fix this problem? Thanks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
