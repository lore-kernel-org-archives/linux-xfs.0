Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6D2B27CBF
	for <xfs@oss.sgi.com>; Sun, 13 Dec 2015 18:42:46 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2D5EF304032
	for <xfs@oss.sgi.com>; Sun, 13 Dec 2015 16:42:45 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	05C5ehCwY9ep3L3G for <xfs@oss.sgi.com>;
	Sun, 13 Dec 2015 16:42:39 -0800 (PST)
Date: Mon, 14 Dec 2015 11:42:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [3.16] xfs: allow inode allocations in post-growfs disk space
Message-ID: <20151214004226.GK26718@dastard>
References: <1449966459.3836.46.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1449966459.3836.46.camel@decadent.org.uk>
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
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Luis Henriques <luis.henriques@canonical.com>, Eric Sandeen <sandeen@redhat.com>, 802885@bugs.debian.org, stable <stable@vger.kernel.org>, xfs@oss.sgi.com

On Sun, Dec 13, 2015 at 12:27:39AM +0000, Ben Hutchings wrote:
> Per the FAQ at
> <http://xfs.org/index.php/XFS_FAQ#Q:_Why_do_I_receive_No_space_left_on_de=
vice_after_xfs_growfs.3F>,
> I think the following commit should be cherry-picked for 3.16-ckt:
> =

> commit 9de67c3ba9ea961ba420573d56479d09d33a7587
> Author: Eric Sandeen <sandeen@redhat.com>
> Date:=A0=A0=A0Thu Jul 24 20:51:54 2014 +1000
> =

> =A0=A0=A0=A0xfs: allow inode allocations in post-growfs disk space

Acked-by: Dave Chinner <david@fromorbit.com>

-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
