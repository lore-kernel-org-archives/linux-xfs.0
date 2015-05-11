Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6EC6D29DFB
	for <xfs@oss.sgi.com>; Mon, 11 May 2015 18:47:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 52FD88F8050
	for <xfs@oss.sgi.com>; Mon, 11 May 2015 16:47:36 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Gd2D7SbBPOozkFeQ for <xfs@oss.sgi.com>;
	Mon, 11 May 2015 16:47:33 -0700 (PDT)
Message-ID: <55513F90.3050704@sandeen.net>
Date: Mon, 11 May 2015 18:47:28 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [ANNOUNCE, DISCUSS] xfsprogs: libxfs-4.1-update branch created
References: <20150511000508.GD16689@dastard> <5550C123.8060806@sandeen.net>
	<20150511212805.GE15721@dastard>
In-Reply-To: <20150511212805.GE15721@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 5/11/15 4:28 PM, Dave Chinner wrote:
>> So; do you envision a 0/8 patch series, 4 of which touch libxfs, to
>> > now be a 0/12 patch series, with the userspace bits i.e. at the end?
>> > I'd be perfectly happy with this; once libxfs stays up to date in
>> > userspace, it should be trivial.
> I'd expect separate patch series, because it's kinda hard to do a
> git send-email or guilt patchbomb that spans mutltiple
> repositories.... :P

Yeah, uh, right.  :)  I knew that.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
