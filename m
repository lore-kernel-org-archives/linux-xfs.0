Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBMAxY8X154199 for <xfs@oss.sgi.com>; Thu, 22 Dec 2011 04:59:35 -0600
Received: from mail.in8.de (brockman.in8.de [85.214.220.56]) by cuda.sgi.com
	with ESMTP id GkQOoZPShjL86OO8 for <xfs@oss.sgi.com>;
	Thu, 22 Dec 2011 02:59:33 -0800 (PST)
Message-ID: <4EF30D93.1090805@jan-o-sch.net>
Date: Thu, 22 Dec 2011 11:59:31 +0100
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: new check 276 to ensure btrfs backref integrity
References: <1323264833-11075-1-git-send-email-list.btrfs@jan-o-sch.net>
	<4EF21BE0.4020009@sandeen.net>
In-Reply-To: <4EF21BE0.4020009@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Thanks for the feedback. I've now removed the $fresh code completely as
it's not meant to be used by anyone but me :-)

_require_btrfs will become a new helper in common.rc. Will resend soon
as 278 (hoping that number holds).

-Jan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
