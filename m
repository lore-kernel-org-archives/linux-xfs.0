Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 98FE57F37
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 04:22:32 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8937E8F8033
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 02:22:29 -0800 (PST)
Received: from youngberry.canonical.com (youngberry.canonical.com
	[91.189.89.112]) by cuda.sgi.com with ESMTP id sLCeNEJcN3wJMIAU
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 02:22:22 -0800 (PST)
Date: Mon, 14 Dec 2015 10:22:13 +0000
From: Luis Henriques <luis.henriques@canonical.com>
Subject: Re: [3.16] xfs: allow inode allocations in post-growfs disk space
Message-ID: <20151214102213.GB3120@ares>
References: <1449966459.3836.46.camel@decadent.org.uk>
	<20151214004226.GK26718@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151214004226.GK26718@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, 802885@bugs.debian.org, Ben Hutchings <ben@decadent.org.uk>, stable <stable@vger.kernel.org>, xfs@oss.sgi.com

On Mon, Dec 14, 2015 at 11:42:26AM +1100, Dave Chinner wrote:
> On Sun, Dec 13, 2015 at 12:27:39AM +0000, Ben Hutchings wrote:
> > Per the FAQ at
> > <http://xfs.org/index.php/XFS_FAQ#Q:_Why_do_I_receive_No_space_left_on_=
device_after_xfs_growfs.3F>,
> > I think the following commit should be cherry-picked for 3.16-ckt:
> > =

> > commit 9de67c3ba9ea961ba420573d56479d09d33a7587
> > Author: Eric Sandeen <sandeen@redhat.com>
> > Date:=A0=A0=A0Thu Jul 24 20:51:54 2014 +1000
> > =

> > =A0=A0=A0=A0xfs: allow inode allocations in post-growfs disk space
> =

> Acked-by: Dave Chinner <david@fromorbit.com>
> =


Thanks, I'm queuing this for the next 3.16 release.

Cheers,
--
Lu=EDs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
