Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 537FD7F51
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 12:40:16 -0500 (CDT)
Date: Wed, 26 Jun 2013 12:40:15 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfstests: .gitignore: add fsync-tester
Message-ID: <20130626174015.GL20932@sgi.com>
References: <20130625153435.7a4eb981@oracle.com>
	<20130626005906.GZ29376@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130626005906.GZ29376@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Dwight Engen <dwight.engen@oracle.com>, xfs@oss.sgi.com

On Wed, Jun 26, 2013 at 10:59:06AM +1000, Dave Chinner wrote:
> On Tue, Jun 25, 2013 at 03:34:35PM -0400, Dwight Engen wrote:
> > Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
> > ---
> >  .gitignore | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/.gitignore b/.gitignore
> > index 0bd48c3..5aa68c3 100644
> > --- a/.gitignore
> > +++ b/.gitignore
> > @@ -47,6 +47,7 @@
> >  /src/fs_perms
> >  /src/fstest
> >  /src/ftrunc
> > +/src/fsync-tester
> >  /src/genhashnames
> >  /src/getdevicesize
> >  /src/getpagesize
> > -- 
> > 1.8.1.4
> 
> Looks good.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Fixed alphabetization.  Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
