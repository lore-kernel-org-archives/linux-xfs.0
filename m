Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8061329DF8
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 11:23:14 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 116AAAC007
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 09:23:10 -0800 (PST)
Received: from vera.uberzach.com (vera.uberzach.com [74.93.97.68]) by
	cuda.sgi.com with ESMTP id b0EnOwS45xzM556z (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 15 Jan 2014 09:23:09 -0800 (PST)
From: Zachary Kotlarek <zach@kotlarek.com>
Subject: [PATCH] Add a warning about non-ASCII filenames in ASCII-CI mode
Date: Wed, 15 Jan 2014 09:23:01 -0800
Message-Id: <1389806582-26815-1-git-send-email-zach@kotlarek.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Correct the typo noted by sgosse@sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
