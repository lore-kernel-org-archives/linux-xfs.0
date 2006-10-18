Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Oct 2006 14:07:51 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9IL7faG011834
	for <xfs@oss.sgi.com>; Wed, 18 Oct 2006 14:07:43 -0700
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.190])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7EA5AD198E29
	for <xfs@oss.sgi.com>; Wed, 18 Oct 2006 13:07:35 -0700 (PDT)
Received: by nf-out-0910.google.com with SMTP id n29so746086nfc
        for <xfs@oss.sgi.com>; Wed, 18 Oct 2006 13:07:34 -0700 (PDT)
Message-ID: <84144f020610181307r7566aa2bp3d7f31388574d457@mail.gmail.com>
Date: Wed, 18 Oct 2006 23:07:33 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: Re: [xfs-masters] Re: [PATCH] fs/xfs: Handcrafted MIN/MAX macro removal
In-Reply-To: <1161193885.5723.168.camel@xenon.msp.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1161169068.20400.149.camel@amol.verismonetworks.com>
	 <1161193885.5723.168.camel@xenon.msp.redhat.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Russell Cattelan <cattelan@thebarn.com>
Cc: Amol Lad <amol@verismonetworks.com>, linux kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On 10/18/06, Russell Cattelan <cattelan@thebarn.com> wrote:
> This change doesn't seem to do anything?

It kills useless wrappers from kernel code making it easier to read
and maintain for _Linux_ developers.
