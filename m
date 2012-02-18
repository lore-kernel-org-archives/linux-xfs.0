Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1ILkA2p192613 for <xfs@oss.sgi.com>; Sat, 18 Feb 2012 15:46:10 -0600
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id M5FTgTgPQHvKNcon (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 18 Feb 2012 13:46:09 -0800 (PST)
Received: from isper.nabble.com ([192.168.236.156])
	by sam.nabble.com with esmtp (Exim 4.72)
	(envelope-from <lists@nabble.com>) id 1Rys6a-0000sa-VD
	for xfs@oss.sgi.com; Sat, 18 Feb 2012 13:46:08 -0800
Message-ID: <33349727.post@talk.nabble.com>
Date: Sat, 18 Feb 2012 13:46:08 -0800 (PST)
From: rlinsurf <jellis@dhnet.us>
Subject: Fatal Error doing make for xfsdump
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


I'm getting the following when I try to make:

FATAL ERROR: attributes.h does not exist.
Install the extended attributes (attr) development package.
Alternatively, run "make install-dev" from the attr source.
make: *** [include/builddefs] Error 1

I can't figure out how to make this not happen. I've tried doing an apt-get
install attr, and that succeeded, and doing the make install-dev from the
attr source, and that succeeded, but the error doesn't go away.

This is ubuntu 10.11. What am I doing wrong?

Thanks.

Best,
Jeffrey 
-- 
View this message in context: http://old.nabble.com/Fatal-Error-doing-make-for-xfsdump-tp33349727p33349727.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
