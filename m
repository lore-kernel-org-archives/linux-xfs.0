Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B83677F51
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 21:59:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 98FDE304043
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 19:59:51 -0700 (PDT)
Received: from Ishtar.hs.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id HQutTtOBMzV5ciuV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 07 Aug 2015 19:59:49 -0700 (PDT)
Message-ID: <55C5709F.8030705@tlinx.org>
Date: Fri, 07 Aug 2015 19:59:43 -0700
From: "L.A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: why crc req on free-inobt & file-type-indir options?
References: <55C41D75.4040504@tlinx.org> <55C43B70.4050300@sandeen.net>
	<55C468F0.2040707@tlinx.org> <20150807225531.GG3902@dastard>
	<55C55265.4080309@tlinx.org>
	<620A4212-818A-4375-90FC-DBB0B91A84DB@sandeen.net>
In-Reply-To: <620A4212-818A-4375-90FC-DBB0B91A84DB@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>



Eric Sandeen wrote:
> 
>> On Aug 7, 2015, at 5:50 PM, L.A. Walsh <xfs@tlinx.org> wrote:
>> Q: should the versions of xfsdump&restore be the same as the rest of the xfsprogs?
> Nope, they are separate packages with separate versioning.
---
I see.  So how does one tell which version of xfsdump/restore should
be used to "safely" dump (and restore) a file system made
with version i.j.k of xfsprogs(mkfs.xfs) ?  Or is that possible?


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
