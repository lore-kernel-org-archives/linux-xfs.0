Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DA8687FF3
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 10:54:19 -0500 (CDT)
Date: Wed, 21 Aug 2013 10:54:16 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: linux-next: build failure after merge of the final tree
Message-ID: <20130821155416.GH5262@sgi.com>
References: <20130820172052.1f0d89ddf6a1a40ef70333fd@canb.auug.org.au>
	<20130820120702.000b044e@oracle.com>
	<20130820192844.GC5262@sgi.com>
	<20130821102246.4e3c4c8fe549d8c7760da96d@canb.auug.org.au>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130821102246.4e3c4c8fe549d8c7760da96d@canb.auug.org.au>
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
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: cbe-oss-dev@lists.ozlabs.org, Arnd Bergmann <arnd@arndb.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dwight Engen <dwight.engen@oracle.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-next@vger.kernel.org, Jeremy Kerr <jk@ozlabs.org>, linuxppc-dev@lists.ozlabs.org, Gao feng <gaofeng@cn.fujitsu.com>

Hey Stephen,

On Wed, Aug 21, 2013 at 10:22:46AM +1000, Stephen Rothwell wrote:
> On Tue, 20 Aug 2013 14:28:44 -0500 Ben Myers <bpm@sgi.com> wrote:
> > I'd prefer not to break Stephen's tree two days in a row.  We could just revert
> > d6970d4b726c in the xfs tree for the time being as Stephen has done, but given
> > the choice would prefer the fix.  Do you have a preference between the two
> > approaches that Dwight has posted?  The first seems more conservative...
> 
> I will automatically revert that commit when I merge the xfs tree until
> some other solution is forthcoming (so you don't have to do the revert in
> the xfs tree).

Gah.  That makes sense.  ;)

> This does need to be fixed fairly soon, though.

Agreed, thanks.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
