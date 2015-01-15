Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (unknown [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E648C7F60
	for <xfs@oss.sgi.com>; Thu, 15 Jan 2015 04:18:47 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 10DA6AC004
	for <xfs@oss.sgi.com>; Thu, 15 Jan 2015 02:18:36 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id ET3pSUln4WRdkFNk (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 15 Jan 2015 02:18:19 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/3] xfs: Quota related cleanups
Date: Thu, 15 Jan 2015 11:18:02 +0100
Message-Id: <1421317085-14350-1-git-send-email-jack@suse.cz>
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
Cc: Jan Kara <jack@suse.cz>

  Hello,

  this series contains quota related cleanups that were part of my series
unifying VFS and XFS quota interfaces. The series is based on for-next branch
of XFS tree. I'd like some XFS guy to review them and either ack them so
that I can merge them through my tree (that would be probably easier for me)
or merge them directly via XFS tree (I can cope as well - I can pull for-next
branch of XFS tree into my tree and base unification series on top of that).

								Honza

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
