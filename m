Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p57BgYrO023032 for <xfs@oss.sgi.com>; Tue, 7 Jun 2011 06:42:35 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EBAAE1ED510B
	for <xfs@oss.sgi.com>; Tue,  7 Jun 2011 04:42:31 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id tkxQFvhLS4AARHbC
	for <xfs@oss.sgi.com>; Tue, 07 Jun 2011 04:42:31 -0700 (PDT)
Message-ID: <4DEE0EA4.9090002@profihost.ag>
Date: Tue, 07 Jun 2011 13:42:28 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: XFS: accounting of reclaimable inodes is incorrect
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

it seems that a bug was backported into the latest 2.6.32 longterm 
stable kernel. Now the patch "XFS: accounting of reclaimable inodes is 
incorrect" needs to get backported to 2.6.32.

Who can help? Who is responsible?

Please CC me i'm not on list.

-- 
Greets,
   Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
