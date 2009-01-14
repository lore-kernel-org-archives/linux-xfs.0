Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0EHbHbD019915 for <xfs@oss.sgi.com>; Wed, 14 Jan 2009 11:37:19 -0600
Message-ID: <496E1F75.8040300@sandeen.net>
Date: Wed, 14 Jan 2009 11:23:01 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS maintainership
References: <200901090619.n096Jp20017008@oss.sgi.com>	<20090109065935.GA1600@infradead.org>	<20090109215218.GB10221@sgi.com>
	<4968E61D.6070505@thebarn.com>	<20090113131855.GB8396@sgi.com>
	<20090114012845.GO8071@disturbed>	<20090114054917.GT8071@disturbed>
	<20090114055050.GU8071@disturbed>
In-Reply-To: <20090114055050.GU8071@disturbed>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Bill O'Donnell <billodo@sgi.com>, Russell Cattelan <cattelan@thebarn.com>, xfs@oss.sgi.com

Dave Chinner wrote:
> It seems to me that SGI wants to maintain control without doing any
> of the work that having that control requires of them.  i.e. take
> without any give....
> 
> Point in case: we have a _critical_ 2.6.28 regression w.r.t.
> directory handling. The community triaged the bug, the community
> fixed the bug and the community reviewed the fix. It got checked
> into the SGI controlled dev tree 4 days ago.  Now we are waiting for
> SGI to stop playing "let's all be one happy family la-la-la" games
> and get off their backsides and *act as responsible maintainers* by
> pushing the fix to Linus ASAP.
> 
> Please, show us that SGI is really going to act as the maintainer of
> XFS. The only thing that will convince me right now that SGI should
> continue as XFS maintainer is this:
> 
> 	"Gesta non verba"

Ooh, bonus points for the Latin!

Since 12/10, when Melbourne got erased, there have only been 6 emails
from sgi to the list which were not from the short-timer skeleton crew
left in Melbourne.  3 of these had something to do with development.   2
were related to this question of maintainership.  1 was a test email.

Meanwhile almost 100 patches have been sent, reviewed, and in many cases
committed by hch & others to the staging trees on kernel.org.  The
proposed new maintainer crew has not participated in this process yet to
any apparent degree.  No questions, no reviews, no acks, no vetoes.
This is not a personal attack by any means, but it seems that it might
reflect the resources available for these tasks inside sgi.

>From my perspective, it certainly appears that much more xfs work is
being done outside sgi than inside sgi at this point in time.  This
*should* be a good thing for sgi, because one of your flagship storage
software offerings is being maintained & moving forward with very few
resource requirements from sgi.

But if sgi's role is simply to own and to veto and not to communicate,
collaborate, facilitate or contribute, sgi will likely find that they've
been left behind in short order.  The internet is famous for routing
around damage.

On the other hand, we're here to help, if you engage us.

-Eric (speaking for myself, not my employer, FWIW)

> Cheers,
> 
> Dave.
> 
> PS: I did say I was going to make myself unpopular :/

Perhaps only with some :)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
