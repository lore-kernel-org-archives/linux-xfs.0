Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7DE277F4E
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 13:10:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1AF59AC00A
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 11:10:09 -0700 (PDT)
Received: from mail-ig0-f174.google.com (mail-ig0-f174.google.com
	[209.85.213.174]) by cuda.sgi.com with ESMTP id
	qHzopjaDQo4FA4RK (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 08 Sep 2014 11:10:07 -0700 (PDT)
Received: by mail-ig0-f174.google.com with SMTP id a13so3215331igq.7
	for <xfs@oss.sgi.com>; Mon, 08 Sep 2014 11:10:07 -0700 (PDT)
Received: from [192.168.1.171] (50-197-102-113-static.hfc.comcastbusiness.net.
	[50.197.102.113])
	by mx.google.com with ESMTPSA id x9sm11608103igl.10.2014.09.08.11.10.06
	for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Mon, 08 Sep 2014 11:10:06 -0700 (PDT)
Message-ID: <540DF0FD.205@gmail.com>
Date: Mon, 08 Sep 2014 14:10:05 -0400
From: Joe Landman <joe.landman@gmail.com>
MIME-Version: 1.0
Subject: converting from external log to internal log ... is this possible?
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

Figured I'd ask, looked on the FAQ and didn't see anything there 
relevant to this.  There is a hint of this in xfs_growfs, specifically 
the -i option, though it is noted that "[NOTE: This option is not 
implemented]".

--
Joe Landman

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
