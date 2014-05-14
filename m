Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7E51D7F3F
	for <xfs@oss.sgi.com>; Wed, 14 May 2014 09:52:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 02239AC00B
	for <xfs@oss.sgi.com>; Wed, 14 May 2014 07:52:04 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id aXeccDcihpBpwMDW for
	<xfs@oss.sgi.com>; Wed, 14 May 2014 07:52:04 -0700 (PDT)
Message-ID: <53738316.20601@redhat.com>
Date: Wed, 14 May 2014 09:52:06 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: Separate mailing list for xfstests
References: <alpine.LFD.2.00.1405141508150.9727@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1405141508150.9727@localhost.localdomain>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>, dchinner@redhat.com
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On 5/14/14, 8:20 AM, Luk=E1=9A Czerner wrote:
> Hi Dave,
> =

> I am wondering whether you're open to the idea of creating separate
> mailing list for xfstests. It is no longer xfs specific project and
> even though you're still a maintainer of the project, other fs folks
> are definitely interested in the development process, but not
> everyone might be interested in receiving everything from the
> xfs@oss.sgi.com list.
> =

> To speak for myself I would like to help with review of xfstests
> patches as well, but I rarely go through my xfs folder
> unfortunately.
> =

> linux-fsdevel might seem as a good candidate for it, but still I
> think that it deserves a separate ML to point people to.
> =

> What do you think ?

That sounds pretty reasonable to me.  We've always encouraged submissions
to cc: the other relevant lists (i.e. linux-ext4 if it's an ext4-specific
patch) and would probably still encourage that, but even from the other
angle (keeping i.e. ext4-specific and btrfs-specific patches off the
xfs list) this sounds like a good idea.

-Eric

> Thanks!
> -Lukas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
