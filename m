Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DE1237F5A
	for <linux-xfs@oss.sgi.com>; Sat,  9 Mar 2013 14:54:52 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BC1E48F8037
	for <linux-xfs@oss.sgi.com>; Sat,  9 Mar 2013 12:54:49 -0800 (PST)
Received: from plane.gmane.org (plane.gmane.org [80.91.229.3]) by cuda.sgi.com
	with ESMTP id YLFhQ23TZygrGL6b (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <linux-xfs@oss.sgi.com>;
	Sat, 09 Mar 2013 12:54:45 -0800 (PST)
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1UEQnI-0007bw-29
	for linux-xfs@oss.sgi.com; Sat, 09 Mar 2013 21:55:04 +0100
Received: from blfd-4db017aa.pool.mediaways.net ([77.176.23.170])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Sat, 09 Mar 2013 21:55:04 +0100
Received: from pa5ca1 by blfd-4db017aa.pool.mediaways.net with local (Gmexim
	0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Sat, 09 Mar 2013 21:55:04 +0100
From: Pascal <pa5ca1@gmx.de>
Subject: Maximum file system size of XFS?
Date: Sat, 9 Mar 2013 21:51:21 +0100
Message-ID: <20130309215121.0e614ef8@thinky>
Mime-Version: 1.0
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
To: linux-xfs@oss.sgi.com

Hello,

I am asking you because I am insecure about the correct answer and
different sources give me different numbers.


My question is: What is the maximum file system size of XFS?

The official page says: 2^63 = 9 x 10^18 = 9 exabytes
Source: http://oss.sgi.com/projects/xfs/

Wikipedia says 16 exabytes.
Source: https://en.wikipedia.org/wiki/XFS

Another reference books says 8 exabytes (2^63).


Can anyone tell me and explain what is the maximum file system size for
XFS?


Thank you in advance!

Pascal

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
