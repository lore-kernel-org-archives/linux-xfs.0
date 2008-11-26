Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAQ3Xjkx003613 for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 21:33:46 -0600
Received: from Russell-Cattelans-MacBook.local (slurp.thebarn.com
	[208.42.117.201]) (authenticated bits=0)
	by slurp.thebarn.com (8.14.0/8.14.0) with ESMTP id mAQ3QvIu005621;
	Tue, 25 Nov 2008 21:26:58 -0600 (CST)
	(envelope-from cattelan@xfs.org)
Message-ID: <492CC201.3080304@xfs.org>
Date: Tue, 25 Nov 2008 21:26:57 -0600
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: New XFS git tree on oss.sgi.com
References: <492BA7AD.5080007@sgi.com> <20081125081644.GA20644@infradead.org>
	<492C0B3D.3040002@thebarn.com> <492CA07F.1030803@sgi.com>
In-Reply-To: <492CA07F.1030803@sgi.com>
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
To: lachlan@sgi.com
Cc: Russell Cattelan <cattelan@thebarn.com>, xfs@oss.sgi.com

Lachlan McIlroy wrote:
> Russell Cattelan wrote:
>> Christoph Hellwig wrote:
>>> On Tue, Nov 25, 2008 at 06:22:21PM +1100, Lachlan McIlroy wrote:
>>>  
>>>> There's a few branches there already:
>>>>
>>>> 'master'      This will contain all the latest xfs changes not yet 
>>>> pushed
>>>>                to mainline.
>>>> 'mainline'    This is vanilla mainline and will updated regularly.
>>>> 'for-linus'   Our staging branch for pull requests
>>>> 'xfs-dev'     This branch will contain KDB and other supporting 
>>>> code for
>>>>                development and should be identical to the old CVS 
>>>> tree.
>>>>
>>>> Feel free to start using it and let us know if you have any issues.
>>>>     
>>>
>>> Any chance to have these as separate git trees instead of branches?
>>>
>>> In either case, do you expect patches against the xfs-dev or the master
>>> tree?  It would also be useful if the trees and which one to be used
>>> could be documented on oss.sgi.com/projects/xfs or xfs.org.
>>>
>>>   
>> Specifically this page please.
>> http://xfs.org/index.php/Getting_the_latest_source_code
> Sure.  I didn't even know that page existed.
>
>>
>> Maybe add a quick tutorial on git branches and how to create tracking 
>> branches for this tree.
> Can we just point people at an existing git tutorial?  Or are you wanting
> something specific to our processes?
most git tutorials seem to be specific to one particular process so 
maybe a link to
a reasonable howto and then a few extra examples blurbs on how to create 
and deal
with tracking branches.

Maybe how to create tracking clones for each branch if that is what 
people want to do.

Personally I like branches as they help keep the tree cluster down and I 
don't have to think
up naming schemes to help me remember what is what, but sounds like some 
people may
like having multiple clones.
>
>>
>> Also can we have something other than "unnamed repository" in the 
>> description file?
> Okay, how do we change that?
>
>>
>>> _______________________________________________
>>> xfs mailing list
>>> xfs@oss.sgi.com
>>> http://oss.sgi.com/mailman/listinfo/xfs
>>>   
>>
>>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
