Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6KNWMb8047172 for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 18:32:22 -0500
Received: from smtp1.linux-foundation.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4361D45E2D1
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 16:35:21 -0700 (PDT)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org
	[140.211.169.13]) by cuda.sgi.com with ESMTP id
	DGyrKzFFqG70IxPt for <xfs@oss.sgi.com>;
	Tue, 20 Jul 2010 16:35:21 -0700 (PDT)
Received: from mail-iw0-f181.google.com (mail-iw0-f181.google.com
	[209.85.214.181]) (authenticated bits=0)
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with
	ESMTP id o6KNZFIe020789
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=FAIL)
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 16:35:20 -0700
Received: by iwn42 with SMTP id 42so5889770iwn.26
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 16:35:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100720233238.GS32635@dastard>
References: <20100720004630.GH23223@dastard> <20100720233238.GS32635@dastard>
Date: Tue, 20 Jul 2010 16:35:14 -0700
Message-ID: <AANLkTil1kuHOTWRGe0o3j2dmrD9TLJSOqdF2IINp4aDx@mail.gmail.com>
Subject: Re: [GIT PULL] Shrinker fixes for XFS for 2.6.36-rc6
From: Linus Torvalds <torvalds@linux-foundation.org>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jul 20, 2010 at 4:32 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> Ijust rebased the series - the shrinker context patch did not pickup
> the new shrinker in the TTM DRM code for radeon. New pull-request output
> below.

Not good. I already pulled the earlier version yesterday. So a rebased
series is useless.

                          Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
