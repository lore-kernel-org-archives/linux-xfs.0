Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DFA3E7CBF
	for <xfs@oss.sgi.com>; Tue, 27 Aug 2013 19:20:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 49746AC006
	for <xfs@oss.sgi.com>; Tue, 27 Aug 2013 17:20:01 -0700 (PDT)
Received: from benjamin.baylink.com (rrcs-24-129-180-187.se.biz.rr.com
	[24.129.180.187]) by cuda.sgi.com with ESMTP id
	JGBNy50yNV8ld0bL for <xfs@oss.sgi.com>;
	Tue, 27 Aug 2013 17:19:56 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by benjamin.baylink.com (Postfix) with ESMTP id CF0581F003E6
	for <xfs@oss.sgi.com>; Tue, 27 Aug 2013 20:19:55 -0400 (EDT)
Received: from benjamin.baylink.com ([127.0.0.1])
	by localhost (benjamin.baylink.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id ooFTv80RgQ+a for <xfs@oss.sgi.com>;
	Tue, 27 Aug 2013 20:19:51 -0400 (EDT)
Received: from benjamin.baylink.com (benjamin.baylink.com [192.168.253.10])
	by benjamin.baylink.com (Postfix) with ESMTP id AD0E71F00325
	for <xfs@oss.sgi.com>; Tue, 27 Aug 2013 20:19:51 -0400 (EDT)
Date: Tue, 27 Aug 2013 20:19:51 -0400 (EDT)
From: Jay Ashworth <jra@baylink.com>
Message-ID: <28029362.5290.1377649191638.JavaMail.root@benjamin.baylink.com>
In-Reply-To: <20130827235949.GA6023@dastard>
Subject: Re: XFS recovery resumes...
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

----- Original Message -----
> From: "Dave Chinner" <david@fromorbit.com>

> Add this to your ~/.screenrc:
> 
> termcapinfo xterm|xterms|xs|rxvt ti@:te@
> 
> And screen will write to the terminal's scrollback buffer rather
> than it's own internal buffer.

Well, sure, but only from whatever screen is active, and they'll all
get mixed together.  There's no real good answer to it...
-- j
-- 
Jay R. Ashworth                  Baylink                       jra@baylink.com
Designer                     The Things I Think                       RFC 2100
Ashworth & Associates     http://baylink.pitas.com         2000 Land Rover DII
St Petersburg FL USA               #natog                      +1 727 647 1274

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
