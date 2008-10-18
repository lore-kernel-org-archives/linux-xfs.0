Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 18 Oct 2008 13:08:32 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9IK8Srs003510
	for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 13:08:29 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E1E151075C2B
	for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 13:10:12 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id dy2vGrDrVdFNirIe for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 13:10:12 -0700 (PDT)
Date: Sat, 18 Oct 2008 16:09:39 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS filesystem corruption on the arm(el) architecture
Message-ID: <20081018200939.GA3779@infradead.org>
References: <1222893502.5020.40.camel@moria> <20081002004556.GB30001@disturbed> <48E4213E.9090508@sandeen.net> <20081016212500.GA27228@deprecation.cyrius.com> <48F7BC9F.4080909@sandeen.net> <20081017070109.GA30726@deprecation.cyrius.com> <20081017094615.GT4504@soziologie.ch> <20081018194851.GA2083@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081018194851.GA2083@localhost.localdomain>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Martin Michlmayr <tbm@cyrius.com>, Eric Sandeen <sandeen@sandeen.net>, Tobias Frost <tobi@coldtobi.de>, linux-kernel@vger.kernel.org, debian-arm@lists.debian.org, xfs@oss.sgi.com

On Sat, Oct 18, 2008 at 10:48:53PM +0300, Kirill A. Shutemov wrote:
> Our team have experience with XFS on ARM OABI on NAS. It worked fine on
> 2.6.12, but got broken on 2.6.17.

So any chance to bisect it down to at least a kernel release where it
stopped working?
