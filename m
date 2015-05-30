Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7F93A7F37
	for <xfs@oss.sgi.com>; Sat, 30 May 2015 17:48:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1CA5FAC002
	for <xfs@oss.sgi.com>; Sat, 30 May 2015 15:48:09 -0700 (PDT)
Received: from mail-wg0-f43.google.com (mail-wg0-f43.google.com
	[74.125.82.43]) by cuda.sgi.com with ESMTP id i5si7N6trwyi3iZv
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 30 May 2015 15:48:07 -0700 (PDT)
Received: by wgme6 with SMTP id e6so87513909wgm.2
	for <xfs@oss.sgi.com>; Sat, 30 May 2015 15:48:06 -0700 (PDT)
Received: from [192.168.1.14] (ip-78-102-144-224.net.upcbroadband.cz.
	[78.102.144.224])
	by mx.google.com with ESMTPSA id n1sm9396223wix.0.2015.05.30.15.48.05
	for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Sat, 30 May 2015 15:48:06 -0700 (PDT)
Message-ID: <556A3E25.6010706@gmail.com>
Date: Sun, 31 May 2015 00:48:05 +0200
From: hallexh@gmail.com
MIME-Version: 1.0
Subject: Overwritten partition
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

Hello,

I accidentally overwritten first 40GB of 36TB XFS partition. I ran
xfs_repair then, which resets the superblocks (I'm sorry i didn't copied
the output of it) and after I mounted the partition, there was no files.
Empty file system, but It should be almost 90% full.

Am I really screwed or there's a chance to recover the data somehow?

Thanks anyone for helping!
John

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
