Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 22 Mar 2008 18:45:27 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2N1jI9r012610
	for <xfs@oss.sgi.com>; Sat, 22 Mar 2008 18:45:19 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 93042125C9FF
	for <xfs@oss.sgi.com>; Sat, 22 Mar 2008 18:45:52 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id W1BEtuTcUVxoZkla for <xfs@oss.sgi.com>; Sat, 22 Mar 2008 18:45:52 -0700 (PDT)
Message-ID: <47E5B64E.5090504@sandeen.net>
Date: Sat, 22 Mar 2008 20:45:50 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH]fix the algorithm for addname in xfs_da_node_lookup_int
References: <47E5AC7D.4080708@gmail.com>
In-Reply-To: <47E5AC7D.4080708@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Kevin Xu <cgxu.gg@gmail.com>
Cc: xfscn@googlegroups.com, xfs@oss.sgi.com

Kevin Xu wrote:
> fix the algorithm for addname in xfs_da_node_lookup_int

Could you please include a bit more of a changelog, i.e. what was broken
and how does this fix it?  Perhaps a testcase, if there is one?

-Eric
