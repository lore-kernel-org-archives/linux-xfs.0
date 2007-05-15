Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 May 2007 12:24:28 -0700 (PDT)
Received: from mail.goop.org (gw.goop.org [64.81.55.164])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4FJOKfB016847
	for <xfs@oss.sgi.com>; Tue, 15 May 2007 12:24:21 -0700
Message-ID: <464A08DC.7030303@goop.org>
Date: Tue, 15 May 2007 12:24:12 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
MIME-Version: 1.0
Subject: Re: 2.6.21-git10/11: files getting truncated on xfs? or maybe an
 nlink problem?
References: <4642389E.4080804@goop.org> <20070509231643.GM85884050@sgi.com> <4642598E.3000607@goop.org> <20070510000119.GO85884050@sgi.com> <46426194.3040403@goop.org> <46439185.5060207@redhat.com> <464392B4.3070009@goop.org> <464393E1.3050705@redhat.com> <46439491.9010604@goop.org> <Pine.LNX.4.61.0705121323030.9570@yvahk01.tjqt.qr> <20070512135143.GG85884050@sgi.com>
In-Reply-To: <20070512135143.GG85884050@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Chuck Ebbert <cebbert@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>, xfs@oss.sgi.com

David Chinner wrote:
> A patch for you to try, Jeremy. I've just started a test run on it...
>   

OK, it seems to work.  I haven't given it an overnight run, but its run
longer without failing than it did before.

    J
