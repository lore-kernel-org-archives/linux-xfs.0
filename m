Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 20A167FDB
	for <xfs@oss.sgi.com>; Tue, 20 Aug 2013 13:28:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9EC7DAC003
	for <xfs@oss.sgi.com>; Tue, 20 Aug 2013 11:28:20 -0700 (PDT)
Message-ID: <5213B526.5000600@redhat.com>
Date: Tue, 20 Aug 2013 14:27:50 -0400
From: Ric Wheeler <rwheeler@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 48/49] xfs: Add read-only support for dirent filetype field
References: <520A53E8.6030604@sgi.com> <20130814075042.GE6023@dastard>
	<20130814184729.GA4604@sgi.com> <520C6E39.7030501@redhat.com>
	<20130815180400.GF3783@sgi.com> <520D4B1B.4080602@redhat.com>
	<20130816140811.GA30422@sgi.com> <20130819052813.GA6023@dastard>
	<20130819184815.GA24096@sgi.com> <20130820022325.GC6023@dastard>
	<20130820143035.GB21663@sgi.com>
In-Reply-To: <20130820143035.GB21663@sgi.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Geoffrey Wehrman <gwehrman@sgi.com>
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On 08/20/2013 10:30 AM, Geoffrey Wehrman wrote:
> The problem is that the maintainer (Ben) listens to all interested parties
> and does not take direction exclusively from you, Red Hat, SuSE, SGI, IBM,
> Oracle, or anyone else.  He is caught in the middle.  Let's be open here.
> The current conflict is the result of me insisting that your plan and
> vision on a specific feature is not in the best interest of the community
> and you do not like the direction I have presented.  It is great that
> you have a vision, but not everyone agrees with your vision.  You are
> definitely the most significant current contributor of code to XFS.
> Of your recent patch set, 49 of 50 patches were accepted.  And the one
> patch that was not accepted, I asked for you to rework.  You refused.
> Mark agreed to rework your patch, and because of this Ben is accused
> of making conflicting decisions based on how each change impacts SGI's
> internal products, not what is in the best interests of the XFS community.
> Last time I checked, SGI was an active member of the XFS community even
> by your definition.  Even so, I believe that the change I am requesting
> will benefit the entire XFS community, not just SGI.  The problem I see
> here is that you are unwilling to compromise on your vision or on your
> interpretation of what is best for the community.
Getting someone to rework a patch is a burden on the one making the request - 
you have to convince them (or the broader list) that you have merit in your 
requested changes.

Usually, the best way to influence an upstream discussion is through submission 
of patches or sharing testing results. It can also be helpful to frame a request 
with a solid "this is what our customers need" type of request.

Regards,

Ric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
