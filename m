Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 06E0D7CBF
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 19:50:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CE53B8F8037
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 17:50:51 -0700 (PDT)
Received: from Ishtar.hs.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id 7OrvkbTSSIz75fsq (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 07 Aug 2015 17:50:50 -0700 (PDT)
Message-ID: <55C55265.4080309@tlinx.org>
Date: Fri, 07 Aug 2015 17:50:45 -0700
From: "L.A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: why crc req on free-inobt & file-type-indir options?
References: <55C41D75.4040504@tlinx.org> <55C43B70.4050300@sandeen.net>
	<55C468F0.2040707@tlinx.org> <20150807225531.GG3902@dastard>
In-Reply-To: <20150807225531.GG3902@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>



Dave Chinner wrote:

> xfsprogs 3.1.11 doesn't support CRCs. 3.2.0 was the first version of
> xfsprogs to support CRCs, and 3.2.1 (IIRC) was the first to support
> finobt, so the make binary came from a different build to the xfs_db
> binary that xfs_admin executes.
----
I'll have to do some research on this.

Q: should the versions of xfsdump&restore be the same as 
the rest of the xfsprogs?





_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
