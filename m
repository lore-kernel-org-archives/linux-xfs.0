Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7EBRvcl144860 for <xfs@oss.sgi.com>; Sat, 14 Aug 2010 06:27:58 -0500
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4A77FCAE983
	for <xfs@oss.sgi.com>; Sat, 14 Aug 2010 04:37:19 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id 2bdgg2xuvDf2Qeow for
	<xfs@oss.sgi.com>; Sat, 14 Aug 2010 04:37:19 -0700 (PDT)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: observed significant performance improvement using "delaylog" in
Date: Sat, 14 Aug 2010 13:28:17 +0200
References: <201008121346.30760.eye.of.the.8eholder@gmail.com>
	<20100813141344.GE10429@dastard> <4C65AE4D.6070502@sandeen.net>
	(sfid-20100814_092305_493513_AC7C6900)
In-Reply-To: <4C65AE4D.6070502@sandeen.net>
MIME-Version: 1.0
Message-Id: <201008141328.18436.Martin@lichtvoll.de>
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
To: xfs@oss.sgi.com
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, Eric Sandeen <sandeen@sandeen.net>, Steven Pratt <slpratt@austin.ibm.com>, Christoph Hellwig <hch@infradead.org>, Stan Hoeppner <stan@hardwarefreak.com>


Hi!

Cc'd Steve as I think he is running the benchmarks.

Am Freitag 13 August 2010 schrieb Eric Sandeen:
> Dave Chinner wrote:
> > On Fri, Aug 13, 2010 at 08:29:07AM -0400, Christoph Hellwig wrote:
> ...
> 
> >> And asking
> >> him/her to add -o delaylog would also be good.
> > 
> > Yes, that would be an interesting comparison...
> 
> I was thinking the same thing; I'll do that.

I think its Steven Pratt from IBM.

Steve, could you add a case for mount option "-o delaylog" to your 
benchmark runs?

----------  Weitergeleitete Nachricht  ----------

Subject: New performance results
Date: Samstag 24 April 2010
From: Steven Pratt <slpratt@austin.ibm.com>
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>

Well, it's been a while but been very busy on other things. Thanks to 
Keith Mannthey for helping get some of these runs done.

New raid performance on 2.6.34-rc3:

http://btrfs.boxacle.net/repository/raid/2010-04-14_2004/2.6.34-
rc3/2.6.34-rc3.html

Also, the long running history graphs are here:

http://btrfs.boxacle.net/repository/raid/history/History.html


Steve


--
[...]
-------------------------------------------------------

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
