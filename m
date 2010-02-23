Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1N1CARt170471 for <xfs@oss.sgi.com>; Mon, 22 Feb 2010 19:12:11 -0600
Date: Mon, 22 Feb 2010 20:14:25 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH 0/2] commit_metadata export operation v6
Message-ID: <20100223011425.GD17409@fieldses.org>
References: <20100217200426.13409.32688.stgit@case>
	<20100220233804.GA15015@fieldses.org>
	<20100222195353.GD10942@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100222195353.GD10942@sgi.com>
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
To: bpm@sgi.com
Cc: linux-nfs@vger.kernel.org, aelder@sgi.com, xfs@oss.sgi.com

On Mon, Feb 22, 2010 at 01:53:53PM -0600, bpm@sgi.com wrote:
> Hey Bruce,
> 
> On Sat, Feb 20, 2010 at 06:38:04PM -0500, J. Bruce Fields wrote:
> > On Wed, Feb 17, 2010 at 02:05:05PM -0600, Ben Myers wrote:
> > > Hey Bruce,
> > > 
> > > Here is the latest version of the knfsd sync changes.  I have addressed the
> > > suggestions provided by Christoph, Trond, Dave, and Alex.
> > > 
> > > In this latest version I have fixed up the few nits in the nfsd patch that
> > > Christoph pointed out yesterday.  I also have simplified the xfs patch as
> > > suggested by Dave.
> > 
> > Thanks, applying.
> > 
> > (Do you the second (xfs) patch to go in through the nfsd tree as well,
> > or should that go in through xfs maintainers after the nfsd merge?)
> 
> I chatted with Alex.  It sounds like the best thing is for both patches
> to go in through the nfsd tree since they need to go in order.

OK, thanks, committed.--b.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
