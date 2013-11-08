Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8DC767FC6
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 23:23:36 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6A422304059
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 21:23:36 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id hBBYGIoCwezSmZsG (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 07 Nov 2013 21:23:32 -0800 (PST)
Message-ID: <527C7594.1020504@oracle.com>
Date: Fri, 08 Nov 2013 13:24:36 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: xfs: update maintainers file
References: <20131107220208.GY1935@sgi.com> <527C0F64.3010906@sgi.com>
	<527C4B27.6020205@redhat.com>
In-Reply-To: <527C4B27.6020205@redhat.com>
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
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Ben Myers <bpm@sgi.com>, elder@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

Hi folks,

I think I'm not the right person to reply this discussion because am still on the road
of how to cooperate with others in open source community, as well as I have not made
much contribution to XFS until now.

However, I'd to show some humble opinions from a user and a trivial developer's point
of view.

First all all, that's fine if we have a co-maintainer who can take the role when Ben
is on leave or busy working on other things, and also, this role may be able to supply
more help to some new comers for patch review, coaching, etc... I felt Mark has already
paid a lot of effort and performed very well in this role.  At least, I got several
offline emails form Mark with the patch review status and comments, which are all helpful
to me. 

Secondly, I want to show respect and admiration to our core developers who are devote
themselves to promote XFS in the past years.  Without those talent guys, I think XFS can
not move ahead rapidly with so much significant performance improvements and new features.
However, how can we credit them for their prominent achievements(i.e, show honor)?
As mentioned above, I have no deep knowledge about the community rule, but I found out
there are several projects are maintained with more than 2 maintainers, e.g, XEN hypervisor
interface, VEM subsystem, a few projects even have 4 maintainers, e.g, TMP driver.
So I was wonder why we can not have more maintainers given that XFS code base become more
and more large(more than one hundred thousand lines via simple `wc -l` though we have much
code comments).

I really felt frustrated from Dave's:"Quite frankly, XFS upstream is completely dysfunctional
right now and, as such, it's no longer a fun thing to work on.", as Dave had made lots of
contributions and going crazy hacking.

I wrote this just because I love this project, I still remember/appreciate Christoph gave me
a quick response to my first email in XFS two years ago, so that I can start to learn kernel
hacking from then on.


Thanks,
-Jeff

On 11/08/2013 10:23 AM, Ric Wheeler wrote:

> Hi Ben,
> 
> How exactly did we decide to add a new co-maintainer? Shouldn't we have
> some discussion on the list and see some substantial history of
> contributions?
> 
> Best regards,
> 
> Ric
> 
> 
> On 11/07/2013 05:08 PM, Mark Tinguely wrote:
>> Updated maintainer info.
>>
>> Signed-off-by: Ben Myers <bpm@sgi.com>
>> Reviewed-by: Mark Tinguely <tinguely@sgi.com>
>> ---
>>  MAINTAINERS |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> Index: b/MAINTAINERS
>> ===================================================================
>> --- a/MAINTAINERS    2013-11-07 15:42:04.554561805 -0600
>> +++ b/MAINTAINERS    2013-11-07 15:42:59.034889770 -0600
>> @@ -9388,7 +9388,7 @@ F:    drivers/xen/*swiotlb*
>>  XFS FILESYSTEM
>>  P:    Silicon Graphics Inc
>>  M:    Ben Myers <bpm@sgi.com>
>> -M:    Alex Elder <elder@kernel.org>
>> +M:    Mark Tinguely <tinguely@sgi.com>
>>  M:    xfs@oss.sgi.com
>>  L:    xfs@oss.sgi.com
>>  W:    http://oss.sgi.com/projects/xfs
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
