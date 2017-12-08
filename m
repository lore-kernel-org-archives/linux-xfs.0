Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:45440 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752100AbdLHRrs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Dec 2017 12:47:48 -0500
Date: Fri, 8 Dec 2017 10:47:47 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [fstests PATCH v6 2/2] generic: add test for DAX MAP_SYNC support
Message-ID: <20171208174747.GA4308@linux.intel.com>
References: <20171207103657.GF2749@eguan.usersys.redhat.com>
 <20171207231950.9023-1-ross.zwisler@linux.intel.com>
 <20171208063610.GH2749@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171208063610.GH2749@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Dan Williams <dan.j.williams@intel.com>, Amir Goldstein <amir73il@gmail.com>

On Fri, Dec 08, 2017 at 02:36:10PM +0800, Eryu Guan wrote:

> (Test was re-numbered as generic/470, BTW.)

Thanks!  For future reference, does the pattern of us submitting tests with
high numbers (generic/999) to avoid merge conflicts and asking you to renumber
them when you merge work for you?  Or would you prefer that we number our
tests to the next available, which may change from submission to submission?
