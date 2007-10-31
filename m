Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 30 Oct 2007 19:35:27 -0700 (PDT)
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9V2ZJWF027701
	for <xfs@oss.sgi.com>; Tue, 30 Oct 2007 19:35:22 -0700
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>)
	id 1In3QR-0006xb-AJ
	for xfs@oss.sgi.com; Tue, 30 Oct 2007 19:35:23 -0700
Message-ID: <13501909.post@talk.nabble.com>
Date: Tue, 30 Oct 2007 19:35:23 -0700 (PDT)
From: "paul.lkw" <paul.lkw@mfun.org>
Subject: 2.6TB Storage Size Problem
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Dear all:
I have a DELL server with a hardware raid controller card and 6 x 750GB
Harddisk, and I configured it as a Raid-5 (5 x 750GB) and 1 of HotSpare. I
partitioned 50GB of the main base CentOS system and the remain unpartitioned
size should be 2.5xxxTB, but however I just have 2.0T as EXT-3 limitation (I
think), How can I use the full size of this with LVM?

THX for all.     ^_^
-- 
View this message in context: http://www.nabble.com/2.6TB-Storage-Size-Problem-tf4722532.html#a13501909
Sent from the Xfs - General mailing list archive at Nabble.com.
