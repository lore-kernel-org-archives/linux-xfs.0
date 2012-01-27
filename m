Return-Path: <xfs-bounces@oss.sgi.com>
Date: Fri, 27 Jan 2012 10:01:37 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: XFS for-next branch
Message-ID: <20120127160137.GJ8262@sgi.com>
References: <20120125171244.GX8262@sgi.com>
	<20120127110533.10304c6a33b83ac8e778915c@canb.auug.org.au>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120127110533.10304c6a33b83ac8e778915c@canb.auug.org.au>
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
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: xfs-masters@oss.sgi.com, linux-next@vger.kernel.org, xfs@oss.sgi.com

Hey Stephen,

On Fri, Jan 27, 2012 at 11:05:33AM +1100, Stephen Rothwell wrote:
> On Wed, 25 Jan 2012 11:12:44 -0600 Ben Myers <bpm@sgi.com> wrote:
> >
> > Could you pull XFS updates from
> > 
> > git://oss.sgi.com/xfs/xfs.git for-next
> > 
> > instead of from the oss/master branch for 3.3?
> 
> OK, currently I fetch the "master" branch of that tree.  And you want em
> to switch to the "for-next" branch, right?  (Those two branches currently
> point to the same commit, so I have not changed yet.)

Yep, please switch to oss/for-next instead of oss/master.  I'll keep
them in sync normally, it's just that I'd like to have a little
flexability WRT what is in for-next.

> Did you mean "3.3", or "3.4"?

I meant only that I'd like to try it this way for a single release, see
how it goes, and then re-evaluate.

> Currently the contacts for that tree are: David Chinner
> <david@fromorbit.com>, xfs-masters@oss.sgi.com.  Should I change that?
> i.e. who has control over the tree and can fix problems if I report them?

I think Dave's suggestion is reasonable:  Keep him as a contact, add me,
and s/xfs-masters@oss.sgi.com/xfs@oss.sgi.com/.  It really helps that
you two are in the same timezone.  ;)

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
