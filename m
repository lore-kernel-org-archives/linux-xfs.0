Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 201497F78
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 09:12:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E55F530406B
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 07:12:44 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id OSR1iolm2JDw01vB for <xfs@oss.sgi.com>;
	Mon, 18 Mar 2013 07:12:43 -0700 (PDT)
Message-ID: <514720E6.3070409@sandeen.net>
Date: Mon, 18 Mar 2013 09:12:54 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsdump: properly set Parent's PID
References: <1359663197-30473-1-git-send-email-cmaiolino@redhat.com>
	<513F58FE.1010200@sgi.com> <513FFC0D.3030705@sandeen.net>
	<20130313124651.GA2816@andromeda.usersys.redhat.com>
	<20130313125856.GB2816@andromeda.usersys.redhat.com>
	<514081A2.9080106@sandeen.net>
	<20130318132117.GA4840@infradead.org>
In-Reply-To: <20130318132117.GA4840@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Rich Johnston <rjohnston@sgi.com>, Carlos Maiolino <cmaiolino@redhat.com>, xfs@oss.sgi.com

On 3/18/13 8:21 AM, Christoph Hellwig wrote:
> On Wed, Mar 13, 2013 at 08:39:46AM -0500, Eric Sandeen wrote:
>> On 3/13/13 7:58 AM, Carlos Maiolino wrote:
>>> Ah, my origin was pointing to the git.kernel.org xfsdump repository =[
>>
>> hch, can we please do something to those repos to make them more obviously
>> deprecated?
> 
> Sorry, I totally forgot about that.  I'll take care of it as soon as I
> get close to the kernel.org PGP key again which I usually keep in a
> physically safe place.    Alternatively any other member of the xfs
> group on kernel.org could take care of it.

hch, I can do "it," but what exactly did you have in mind?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
