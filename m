Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 21 Nov 2006 11:42:59 -0800 (PST)
Received: from mail.g-house.de (ns2.g-housing.de [81.169.133.75])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kALJgkaG005295
	for <xfs@oss.sgi.com>; Tue, 21 Nov 2006 11:42:47 -0800
Date: Tue, 21 Nov 2006 19:09:41 +0000 (GMT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: 2.6.19-rc5-git4 benchmarks
Message-ID: <Pine.LNX.4.64.0611211802570.6933@sheep.housecafe.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: ext3-users@redhat.com
Cc: jfs-discussion@lists.sourceforge.net, linux-crypto@nl.linux.org, reiserfs-list@namesys.com, xfs@oss.sgi.com

Apologies for the wide alias, but as it may interest serveral
fs groups, here it is:

In the everlasting search for the best fs for my shiny new disks, I
was interested in some numbers, here're the results:

http://nerdbynature.de/bench/amd64/2.6.19-rc5-git4/test-3/dm-crypt-3.html

details: http://nerdbynature.de/wp/?cat=4

(in short: ext3 pretty fast in all operations. then again, the numbers 
suggest that sometimes a crypto-fs is faster than withou crypto, eg.
'ext3_no-cipher' vs. 'ext3_aes-cbc-essiv:md5'...that's strange, no?)

Thanks,
Christian.
-- 
BOFH excuse #11:

magnetic interference from money/credit cards
