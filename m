Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3JMEvlZ012393 for <xfs@oss.sgi.com>; Sun, 19 Apr 2009 17:14:57 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 59A2130408C
	for <xfs@oss.sgi.com>; Sun, 19 Apr 2009 15:14:50 -0700 (PDT)
Message-Id: <0919D52D-307F-4259-B4A6-2A585E2141A5@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <49EB9CC3.1000305@sandeen.net>
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH] xfstests: skip fsr tests if xfs_fsr utils not found
Date: Sun, 19 Apr 2009 17:14:49 -0500
References: <49EB8F90.20705@sandeen.net> <49EB9CC3.1000305@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>


On Apr 19, 2009, at 4:50 PM, Eric Sandeen wrote:

> Similar to the xfsdump-related patch; gracefully fail
> if no xfs_fsr is found.
>
> I'll probably send another for the acl & attr userspace,
> it's actually not always installed on minimal boxes.
>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Looks good.

Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
