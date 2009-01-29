Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0T5SEE8178166 for <xfs@oss.sgi.com>; Wed, 28 Jan 2009 23:28:16 -0600
Message-ID: <49813E27.9010309@sgi.com>
Date: Thu, 29 Jan 2009 16:27:03 +1100
From: Mark Goodwin <markgw@sgi.com>
MIME-Version: 1.0
Subject: Re: xfs open questions
References: <200901270928.29215@zmi.at>
	<497F130F.4010107@sandeen.net>	<200901280937.23743@zmi.at>
	<498025D2.1060706@sgi.com> <4980754D.5060203@sandeen.net>
In-Reply-To: <4980754D.5060203@sandeen.net>
Reply-To: markgw@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com



Eric Sandeen wrote:
> Mark Goodwin wrote:
>> Michael Monnerie wrote:
>>> On Dienstag 27 Januar 2009 Eric Sandeen wrote:
>>>> I'd love to be able to update these pdf files, but despite asking for
>>>> the source document several times over a couple months, nothing has
>>>> been provided.  Unfortunately 'til then it's up to SGI to update them
>>>> and the community can't help much (SGI: hint, hint).
>> it's (finally) on the Open Source Review Board meeting agenda
>> for tomorrow (6am in my TZ :) I expect to release the src docs
>> shortly after that; the oss release process is time consuming.
>
> Thanks for the update Mark, that's good news.  Sorry for being snippy.
> I do know how these things go...  ;)
>
> -Eric

well it's now been approved for release under the GNU FDL to be hosted
on oss.sgi.com. I guess one question now is how to deal with the proprietary
doc & ppt binary formats. My first thought was another git repository at
git://oss/xfs/cmds/xfsdocs.git which would also include the web site html
content. But doc and ppt binary files apparently always result in git merge
conflicts (can't be patched) ... thoughts?  Perhaps convert the content
to wiki or maybe html and manage changes that way?

Cheers
-- Mark

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
