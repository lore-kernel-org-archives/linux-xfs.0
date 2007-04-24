Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Apr 2007 15:55:58 -0700 (PDT)
Received: from smtp104.sbc.mail.mud.yahoo.com (smtp104.sbc.mail.mud.yahoo.com [68.142.198.203])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3OMtsfB023573
	for <xfs@oss.sgi.com>; Tue, 24 Apr 2007 15:55:55 -0700
Date: Tue, 24 Apr 2007 15:55:51 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: system freeze with xfs
Message-ID: <20070424225551.GA17832@tuatara.stupidest.org>
References: <1177433458.3360.12.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177433458.3360.12.camel@localhost.localdomain>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jurgen Schulz <jmschulz@earthlink.net>
Cc: xfs@oss.sgi.com

On Tue, Apr 24, 2007 at 09:50:57AM -0700, Jurgen Schulz wrote:

> Fedora Core 5 2.6.20-1.2312.fc5 #1 Tue Apr 10 15:09:44 EDT 2007 i686 athlon i386 GNU/Linux

Smells like 4k stack on i386 blowing up; try w/o the 4k stacks option
and see how that hold up
