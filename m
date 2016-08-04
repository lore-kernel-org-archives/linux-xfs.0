Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C89F47CA0
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2016 17:48:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 995D3304053
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2016 15:48:36 -0700 (PDT)
Received: from mu-mail3.massey.ac.nz (mu-mail3.massey.ac.nz [130.123.129.187])
	by cuda.sgi.com with ESMTP id PlDOoeSWd9XMle6l for
	<xfs@oss.sgi.com>; Thu, 04 Aug 2016 15:48:34 -0700 (PDT)
Received: from tur-mm4.massey.ac.nz (tur-mm4.massey.ac.nz [130.123.96.132])
	by mu-mail3.massey.ac.nz (Postfix) with ESMTP id 24B6F1B2E8E
	for <xfs@oss.sgi.com>; Fri,  5 Aug 2016 10:48:33 +1200 (NZST)
From: "Rynhart, Patrick" <P.Rynhart@massey.ac.nz>
Subject: Programmatically query default XFS Quota ?
Date: Thu, 4 Aug 2016 22:48:32 +0000
Message-ID: <839565DD1303AC4993B245FFDB34AF78510C9C8F@tur-exch-node1.massey.ac.nz>
Content-Language: en-US
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
To: "'xfs@oss.sgi.com'" <xfs@oss.sgi.com>

Hi,

I can set a default quota on a file system as follows:

xfs_quota -x -c 'limit bsoft=100m bhard=100m -d' /home

But I'm not sure how to query this - can anyone advise ?

Thanks in Advance,

Patrick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
