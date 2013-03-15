Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B73718034
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 11:01:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 881D58F804C
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 09:01:27 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id DR9pVW3E9kWPcGut for <xfs@oss.sgi.com>;
	Fri, 15 Mar 2013 09:01:26 -0700 (PDT)
Message-ID: <514345D5.8090005@sandeen.net>
Date: Fri, 15 Mar 2013 11:01:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH V2] xfstests: test writing to device node on an RO
	filesystem
References: <514243C0.1000309@redhat.com> <5142896E.9060609@sandeen.net>
	<5143457A.6060303@sgi.com>
In-Reply-To: <5143457A.6060303@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 3/15/13 10:59 AM, Rich Johnston wrote:
> Eric,
> 
> Thanks again for the new test. A few minor issues that can be corrected at commit time.
> 
> Reviewed-by: Rich Johnston <rjohnston@sgi.com>
> 
> I can correct this a commit time.
> 
> quilt refresh
> Warning: trailing whitespace in line 24 of 306
> Refreshed patch patches/V2-xfstests-test-writing-to-device-node-on-an-RO-filesystem.patch
> 
> Do you also want me to add this top the quick group as Dave suggested when I commit this?

Sure, thanks for that, and sorry my patches always seem so sloppy.  I mean well, and I try.  I'll try harder. ;)

-Eric

> Thanks
> --Rich
> 
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
