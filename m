Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Jul 2007 13:26:58 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-4.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6NKQrbm022355
	for <xfs@oss.sgi.com>; Mon, 23 Jul 2007 13:26:55 -0700
Received: from schroedinger.engr.sgi.com (schroedinger.engr.sgi.com [150.166.1.51])
	by netops-testserver-4.corp.sgi.com (Postfix) with ESMTP id 26AE761B24
	for <xfs@oss.sgi.com>; Mon, 23 Jul 2007 13:08:01 -0700 (PDT)
Date: Mon, 23 Jul 2007 12:19:22 -0700
From: Christoph Lameter <clameter@sgi.com>
Subject: Re: 2.6.21.3 Oops (was Re: XFS internal error xfs_da_do_buf(2) at
 line 2087 of file fs/xfs/xfs_da_btree.c. Caller 0xc01b00bd)
Message-ID: <20070723121922.1b347eac@schroedinger.engr.sgi.com>
In-Reply-To: <BAY103-DAV5C915E9475BFB6180B585B2170@phx.gbl>
References: <BAY103-DAV717DD455F57B3BB064E3CB2100@phx.gbl>
	<Pine.LNX.4.64.0706211121520.7711@schroedinger.engr.sgi.com>
	<BAY103-DAV5C915E9475BFB6180B585B2170@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Marco Berizzi <pupilla@hotmail.com>
Cc: Satyam Sharma <satyam.sharma@gmail.com>, linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>

On Fri, 22 Jun 2007 11:22:09 +0200
"Marco Berizzi" <pupilla@hotmail.com> wrote:

> With the same kernel or should I compile with
> some other options?

With the same kernel. No additional options are needed. 
