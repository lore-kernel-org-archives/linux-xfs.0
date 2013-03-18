Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A32917F37
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 08:21:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7FCC030406B
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 06:21:26 -0700 (PDT)
Date: Mon, 18 Mar 2013 09:21:17 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsdump: properly set Parent's PID
Message-ID: <20130318132117.GA4840@infradead.org>
References: <1359663197-30473-1-git-send-email-cmaiolino@redhat.com>
	<513F58FE.1010200@sgi.com> <513FFC0D.3030705@sandeen.net>
	<20130313124651.GA2816@andromeda.usersys.redhat.com>
	<20130313125856.GB2816@andromeda.usersys.redhat.com>
	<514081A2.9080106@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <514081A2.9080106@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, Rich Johnston <rjohnston@sgi.com>, Carlos Maiolino <cmaiolino@redhat.com>, xfs@oss.sgi.com

On Wed, Mar 13, 2013 at 08:39:46AM -0500, Eric Sandeen wrote:
> On 3/13/13 7:58 AM, Carlos Maiolino wrote:
> > Ah, my origin was pointing to the git.kernel.org xfsdump repository =[
> 
> hch, can we please do something to those repos to make them more obviously
> deprecated?

Sorry, I totally forgot about that.  I'll take care of it as soon as I
get close to the kernel.org PGP key again which I usually keep in a
physically safe place.    Alternatively any other member of the xfs
group on kernel.org could take care of it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
