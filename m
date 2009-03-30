Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2UFIM0Q201505 for <xfs@oss.sgi.com>; Mon, 30 Mar 2009 10:18:33 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E7A913DBC09
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2009 08:18:41 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id EIL4keObAoiZW9nL for <xfs@oss.sgi.com>;
	Mon, 30 Mar 2009 08:18:41 -0700 (PDT)
Message-ID: <49D0E28B.4090207@sandeen.net>
Date: Mon, 30 Mar 2009 10:17:31 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Regression? 2.6.27-rc3 segfault on cold boot; not on warm boot.
References: <48AD3921.5090709@dgreaves.com> <200808212026.17590.rjw@sisk.pl>
	<48AFDCE7.7010508@dgreaves.com>
In-Reply-To: <48AFDCE7.7010508@dgreaves.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: David Greaves <david@dgreaves.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, xfs@oss.sgi.com

David Greaves wrote:
> Rafael J. Wysocki wrote:
>> [Adding CCs]
>>
>> [The issue is probably present in 2.6.26 too]
> 
> Yes, below is a netconsole boot of 2.26.6.3
> 
> I cold booted - lots of segfaults. I then did a ctrl-Alt-SysRq-S-U-B to a warm
> boot. No segfaults
> (lots of #### mark the split)
> 
> I've just started 2.6.25.14 building for tomorrow to confirm how far back it
> goes. (I'm 99% sure 2.6.25 is OK)
> 
> David

(trimming cc's to xfs)

David, did you get anywhere with identifying this further?

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
