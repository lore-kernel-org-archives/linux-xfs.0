Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 882017F3F
	for <xfs@oss.sgi.com>; Fri, 20 Jun 2014 01:47:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F02EAAC005
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2014 23:47:15 -0700 (PDT)
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id o2fqFHeIoRsCDVZo (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Jun 2014 23:47:14 -0700 (PDT)
Received: from tom.nabble.com ([192.168.236.105])
	by sam.nabble.com with esmtp (Exim 4.72)
	(envelope-from <metaverse@artikel-140.nl>) id 1WxsbR-0004FX-By
	for xfs@oss.sgi.com; Thu, 19 Jun 2014 23:47:13 -0700
Date: Thu, 19 Jun 2014 23:47:13 -0700 (PDT)
From: metaverse <metaverse@artikel-140.nl>
Message-ID: <1403246832932-35023.post@n7.nabble.com>
Subject: Create superblock
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Last week a harddrive in a NAS crashed in our office.  Long story short: We
have been trying everything. In the end we where able to pull an image of
the hard drive. Also we found out there's no superblock or secondary blocks.
Since I have recovered successfully the data I was wondering if it was
possible to create a new superblock and secondary block. If not I'll create
a new partition and place all the data back. 

Scary that only a power outage can do this...

TL;DR: Is it possible to create a new superblock from scratch?



--
View this message in context: http://xfs.9218.n7.nabble.com/Create-superblock-tp35023.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
