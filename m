Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1E9nNvP082317 for <xfs@oss.sgi.com>; Tue, 14 Feb 2012 03:49:23 -0600
Received: from smtprelay02.ispgateway.de (smtprelay02.ispgateway.de
	[80.67.31.29]) by cuda.sgi.com with ESMTP id AI9QyjJIee6yUhsy
	for <xfs@oss.sgi.com>; Tue, 14 Feb 2012 01:49:22 -0800 (PST)
Message-ID: <4F3A2E1F.5030204@cape-horn-eng.com>
Date: Tue, 14 Feb 2012 10:49:19 +0100
From: Richard Ems <richard.ems@cape-horn-eng.com>
MIME-Version: 1.0
Subject: Re: XFS unlink still slow on 3.1.9 kernel ?
References: <20120213170825.GA7197@infradead.org>
	<4F394442.9020307@cape-horn-eng.com>
	<20120213171556.GA13449@infradead.org>
	<4F3947D6.5060402@cape-horn-eng.com>
	<20120213172937.GA25248@infradead.org>
	<4F394E10.9000804@cape-horn-eng.com>
	<20120213180220.GA24163@infradead.org>
	<4F395134.8030202@cape-horn-eng.com>
	<20120213181012.GA27962@infradead.org>
	<4F395B1A.7010709@cape-horn-eng.com>
	<20120213211654.GA20192@infradead.org>
In-Reply-To: <20120213211654.GA20192@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 02/13/2012 10:16 PM, Christoph Hellwig wrote:
> On Mon, Feb 13, 2012 at 07:48:58PM +0100, Richard Ems wrote:
>> I already updated to 3.2.4 and started the same "find dir" command again
>> that previously took 100 min to run. It has been running now for over 30
>> min ...
>>
>> Should this "find" run time also improve ?
> =

> No, not by that change anyway.
> =

>> Or will only unlink run time improve ?
> =

> Yes.

I see no improvement at all.   :(


-- =

Richard Ems       mail: Richard.Ems@Cape-Horn-Eng.com

Cape Horn Engineering S.L.
C/ Dr. J.J. D=F3mine 1, 5=BA piso
46011 Valencia
Tel : +34 96 3242923 / Fax 924
http://www.cape-horn-eng.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
