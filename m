Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EAB997F7C
	for <xfs@oss.sgi.com>; Wed,  8 Apr 2015 21:14:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CCEC88F8039
	for <xfs@oss.sgi.com>; Wed,  8 Apr 2015 19:14:23 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Ax91bZPzwahguLEY for <xfs@oss.sgi.com>;
	Wed, 08 Apr 2015 19:14:18 -0700 (PDT)
Date: Thu, 9 Apr 2015 12:14:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: hard reboot, no XFS messages
Message-ID: <20150409021403.GE13731@dastard>
References: <296cad845fb1a5c610adf6d9975d3a95@posteo.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <296cad845fb1a5c610adf6d9975d3a95@posteo.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Malte Gell <mailinglisten@posteo.de>
Cc: XFS <xfs@oss.sgi.com>

On Thu, Apr 09, 2015 at 02:52:55AM +0200, Malte Gell wrote:
> Hi there,
> I=B4m totally new to XFS.
> =

> Recently my Linux box was stuck and I had to reboot it hard.
> After the reboot I was surprised, there were no error messages or
> corrupt inodes.
> =

> Usually on my ext4 root partition there are always some damaged
> inodes that get deleted. But my /home XFS partition seemed to have
> suffered zero effect from cold reboot.
> =

> Is this normal for XFS that a cold reboot is handled that smooth?

Normal.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
